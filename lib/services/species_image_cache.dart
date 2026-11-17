import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Small persistent photo cache shared by Android and Web. Not a remote upload.
/// Bounded to 6 MiB of image bytes; oldest photos may be evicted.
class SpeciesImageCache {
  static const maxImageBytes = 512 * 1024;
  static const maxCacheBytes = 6 * 1024 * 1024;
  static const _prefix = 'toxid_photo_cache_v1:';
  static final _pending = <String, Future<Uint8List>>{};
  static Future<void> _writes = Future<void>.value();

  static String _key(String url) =>
      '$_prefix${base64Url.encode(utf8.encode(url))}';

  static Future<Uint8List> load(String url) {
    final value = url.trim();
    return _pending.putIfAbsent(value, () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString(_key(value));
        if (stored != null) {
          try {
            final bytes = base64Decode(stored);
            await _validate(bytes);
            return bytes;
          } catch (_) { await prefs.remove(_key(value)); }
        }
        return await _download(value);
      } finally { _pending.remove(value); }
    });
  }

  static Future<void> _validate(Uint8List bytes) async {
    if (bytes.isEmpty || bytes.length > maxImageBytes) {
      throw StateError('Use uma imagem de até 512 KB.');
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    try {
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      try {
        if (descriptor.width > 2048 || descriptor.height > 2048) {
          throw StateError('Use uma imagem com até 2048 pixels por lado.');
        }
      } finally { descriptor.dispose(); }
    } finally { buffer.dispose(); }
  }

  static Future<Uint8List> _download(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw StateError('Informe um link HTTPS direto para uma imagem.');
    }
    final client = http.Client();
    try {
      final bytes = await (() async {
        final response = await client.send(http.Request('GET', uri));
        if (response.statusCode != 200) {
          throw StateError('Não foi possível baixar a foto (HTTP ${response.statusCode}).');
        }
        if ((response.contentLength ?? 0) > maxImageBytes) {
          throw StateError('Use uma imagem de até 512 KB.');
        }
        final data = BytesBuilder(copy: false);
        await for (final chunk in response.stream) {
          if (data.length + chunk.length > maxImageBytes) {
            throw StateError('Use uma imagem de até 512 KB.');
          }
          data.add(chunk);
        }
        return data.takeBytes();
      })().timeout(const Duration(seconds: 15));
      await _validate(bytes);
      final write = _writes.then((_) => _save(url, bytes));
      _writes = write.then<void>((_) {}, onError: (Object _, StackTrace __) {});
      await write;
      return bytes;
    } finally { client.close(); }
  }

  static Future<void> _save(String url, Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(url);
    final keys = prefs.getStringList('toxid_photo_order_v1') ?? <String>[];
    keys.remove(key);
    var used = 0;
    for (final k in keys) {
      used += ((prefs.getString(k)?.length ?? 0) * 3 ~/ 4);
    }
    while (keys.isNotEmpty && used + bytes.length > maxCacheBytes) {
      final old = keys.removeAt(0);
      used -= ((prefs.getString(old)?.length ?? 0) * 3 ~/ 4);
      await prefs.remove(old);
    }
    if (!await prefs.setString(key, base64Encode(bytes))) {
      throw StateError('Não foi possível guardar a foto neste aparelho.');
    }
    keys.add(key);
    await prefs.setStringList('toxid_photo_order_v1', keys);
  }
}

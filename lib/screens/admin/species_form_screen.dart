import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../services/species_image_cache.dart';
import 'package:provider/provider.dart';
import '../../models/species.dart';
import '../../domain/species_labels.dart';
import '../../services/species_service.dart';
import '../../theme/app_theme.dart';

/// Formulário de Cadastro e Edição de Espécies (CRUD - Create & Update).
class SpeciesFormScreen extends StatefulWidget {
  final Species? speciesToEdit;

  const SpeciesFormScreen({super.key, this.speciesToEdit});

  @override
  State<SpeciesFormScreen> createState() => _SpeciesFormScreenState();
}

class _SpeciesFormScreenState extends State<SpeciesFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _commonNameCtrl;
  late TextEditingController _scientificNameCtrl;
  late TextEditingController _antivenomCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _distCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _colorsCtrl;
  late TextEditingController _characteristicsCtrl;

  String _category = 'Répteis';
  String _dangerLevel = 'Muito perigosa';
  bool _isSaving = false;
  bool _checkingPhoto = false;
  Uint8List? _preview;
  String? _photoMessage;

  Future<void> _testPhoto() async {
    final url = _imageCtrl.text.trim();
    setState(() { _checkingPhoto = true; _preview = null; _photoMessage = null; });
    try {
      final bytes = await SpeciesImageCache.load(url);
      if (!mounted || _imageCtrl.text.trim() != url) return;
      setState(() {
        _preview = bytes;
        _photoMessage = 'Foto disponível neste aparelho, inclusive sem internet.';
      });
    } catch (e) {
      if (mounted && _imageCtrl.text.trim() == url) {
        setState(() => _photoMessage = 'Falha ao testar a foto: $e');
      }
    } finally {
      if (mounted) setState(() => _checkingPhoto = false);
    }
  }


  final List<String> _categories = ['Répteis', 'Aracnídeos', 'Anfíbios', 'Insetos'];
  final List<String> _dangerLevels = ['Muito perigosa', 'Perigosa', 'Baixo perigo', 'Não perigosa'];

  @override
  void initState() {
    super.initState();
    final s = widget.speciesToEdit;
    _commonNameCtrl = TextEditingController(text: s?.commonName ?? '');
    _scientificNameCtrl = TextEditingController(text: s?.scientificName ?? '');
    _antivenomCtrl = TextEditingController(text: s?.antivenom ?? '');
    _descCtrl = TextEditingController(text: s?.description ?? '');
    _distCtrl = TextEditingController(text: s?.distribution ?? '');
    _imageCtrl = TextEditingController(text: s?.imageUrl ?? '');
    _colorsCtrl = TextEditingController(text: s?.colors.map(colorLabel).join(', ') ?? '');
    _characteristicsCtrl = TextEditingController(text: s?.characteristics.join(', ') ?? '');

    if (s != null) {
      if (_categories.contains(categoryLabel(s.category))) _category = categoryLabel(s.category);
      if (_dangerLevels.contains(dangerLabel(s.dangerLevel))) _dangerLevel = dangerLabel(s.dangerLevel);
    }
  }

  @override
  void dispose() {
    _commonNameCtrl.dispose();
    _scientificNameCtrl.dispose();
    _antivenomCtrl.dispose();
    _descCtrl.dispose();
    _distCtrl.dispose();
    _imageCtrl.dispose();
    _colorsCtrl.dispose();
    _characteristicsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final service = Provider.of<SpeciesService>(context, listen: false);

    final colorsList = _colorsCtrl.text
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    final charsList = _characteristicsCtrl.text
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    final newOrUpdated = Species(
      id: widget.speciesToEdit?.id ?? '',
      commonName: _commonNameCtrl.text.trim(),
      scientificName: _scientificNameCtrl.text.trim(),
      category: _category,
      dangerLevel: _dangerLevel,
      antivenom: _antivenomCtrl.text.trim(),
      colors: colorsList,
      characteristics: charsList,
      description: _descCtrl.text.trim(),
      distribution: _distCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim(),
      firstAidDo: widget.speciesToEdit?.firstAidDo ?? [
        'Mantenha a vítima em repouso e calma',
        'Lave a região com água e sabão',
        'Procure hospital imediatamente',
      ],
      firstAidDont: widget.speciesToEdit?.firstAidDont ?? [
        'NÃO faça torniquetes',
        'NÃO corte o local da picada',
        'NÃO tente sugar o veneno',
      ],
    );

    bool ok;
    if (widget.speciesToEdit == null) {
      ok = await service.createSpecies(newOrUpdated);
    } else {
      ok = await service.updateSpecies(newOrUpdated);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(service.errorMessage ?? 'Não foi possível salvar.')));
    }

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.speciesToEdit == null
              ? 'Espécie adicionada com sucesso!'
              : 'Espécie atualizada com sucesso!'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.speciesToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Espécie' : 'Nova Espécie'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _commonNameCtrl,
                  decoration: const InputDecoration(labelText: 'Nome Popular *'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _scientificNameCtrl,
                  decoration: const InputDecoration(labelText: 'Nome Científico *'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _category,
                        decoration: const InputDecoration(labelText: 'Categoria'),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _dangerLevel,
                        decoration: const InputDecoration(labelText: 'Perigo'),
                        items: _dangerLevels.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) => setState(() => _dangerLevel = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _antivenomCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Soro Antiveneno Indicado *',
                    hintText: 'Ex: SAB - Soro Antibotrópico',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o antiveneno' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _colorsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cores (separadas por vírgula)',
                    hintText: 'Marrom, Amarelo, Preto',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _characteristicsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Características Marcantes (para triagem)',
                    hintText: 'Possui chocalho, manchas ou losangos',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _distCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Distribuição Geográfica',
                    hintText: 'Cerrado, Mata Atlântica...',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _imageCtrl,
                  onChanged: (_) => setState(() { _preview = null; _photoMessage = null; }),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty || text.startsWith('assets/visual/')) return null;
                    final uri = Uri.tryParse(text);
                    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
                        ? null : 'Use um link HTTPS direto para a foto.';
                  },
                  decoration: const InputDecoration(
                    labelText: 'URL da Imagem ou Caminho Asset',
                    hintText: 'https://seu-site/especies/foto.webp',
                    helperText: 'Link direto HTTPS. Até 512 KB e 2048 px por lado.',
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _checkingPhoto || _isSaving ? null : _testPhoto,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(_checkingPhoto ? 'Baixando foto...' : 'Testar link e guardar foto'),
                ),
                if (_photoMessage != null) Text(_photoMessage!),
                if (_preview != null) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Image.memory(_preview!, height: 180, fit: BoxFit.contain),
                ),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descrição Biológica / Sintomas',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Atualizar Espécie' : 'Salvar Nova Espécie',
                          style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

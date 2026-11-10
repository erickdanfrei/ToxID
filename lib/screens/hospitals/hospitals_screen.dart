import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/hospital.dart';
import '../../domain/hospital_serum_filter.dart';
import '../../services/hospital_route_service.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../services/hospital_service.dart';
import '../../services/location_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hospital_card.dart';

/// Tela de Localização dos Hospitais de Referência.
/// Atende a:
/// - RF05: Lista de hospitais ordenados por proximidade.
/// - RNF06: Conformidade com LGPD (geolocalização estritamente temporária).
/// - RF11: Discagem direta de emergência.
class HospitalsScreen extends StatefulWidget {
  final String? requiredSerum;

  const HospitalsScreen({super.key, this.requiredSerum});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final LocationService _locationService = LocationService();
  double? _userLat, _userLng;
  bool _isLocating = false, _enabled = false, _ready = false, _routing = false;
  String _locationStatus = 'Referências com soros cadastrados. Ative o GPS para ordenar por proximidade.';
  String _routeStatus = '';
  final _map = MapController();
  final _routes = HospitalRouteService();
  NetworkTileProvider? _tiles;
  Hospital? _selected;
  HospitalRoute? _route;
  int _request = 0;

  @override
  void dispose() {
    _request++;
    _map.dispose();
    _routes.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    if (_isLocating) return;
    if (!_enabled) {
      final agreed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ativar mapa?'),
          content: const Text(
            'O mapa usa internet e envia a região visualizada ao provedor do mapa. Os hospitais vêm do cadastro do ToxID. Ao traçar uma rota, origem e destino são enviados ao serviço de rotas.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ativar'),
            ),
          ],
        ),
      );
      if (agreed != true || !mounted) return;
      _tiles = NetworkTileProvider(
        cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(
          maxCacheSize: 50000000,
        ),
      );
    }
    _request++;
    setState(() {
      _enabled = true;
      _isLocating = true;
      _route = null;
      _selected = null;
      _routing = false;
      _routeStatus = '';
      _locationStatus = 'Obtendo GPS…';
    });
    try {
      final p = await _locationService.getCurrentPosition();
      if (!mounted) return;
      if (p == null) {
        setState(() {
          _userLat = null;
          _userLng = null;
          _locationStatus =
              'GPS indisponível. Permita localização e tente novamente.';
        });
        return;
      }
      setState(() {
        _userLat = p.latitude;
        _userLng = p.longitude;
      });
      if (_ready) _map.move(LatLng(p.latitude, p.longitude), 12);
      setState(() {
        _locationStatus = 'Referências ordenadas por proximidade. Soros informados no cadastro; confirme a disponibilidade com a unidade.';
      });
    } catch (_) {
      if (mounted)
        setState(
          () => _locationStatus =
              'GPS indisponível. Exibindo apenas referências com soros cadastrados, sem ordenar por distância.',
        );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _select(Hospital hospital) async {
    if (_isLocating) return;
    if (!_enabled) {
      await _fetchLocation();
      if (!mounted || !_enabled) return;
    }
    final token = ++_request;
    setState(() {
      _selected = hospital;
      _route = null;
      _routing = true;
      _routeStatus = 'Calculando rota…';
    });
    if (_userLat == null || _userLng == null) {
      setState(() {
        _routing = false;
        _routeStatus = 'Ative o GPS para traçar a rota. Você também pode abrir a navegação externa.';
      });
      return;
    }
    try {
      final route = await _routes.fetch(
        LatLng(_userLat!, _userLng!),
        LatLng(hospital.latitude, hospital.longitude),
      );
      if (!mounted || token != _request) return;
      setState(() {
        _route = route;
        _routeStatus =
            '${(route.meters / 1000).toStringAsFixed(1)} km pela via • ${(route.seconds / 60).ceil()} min estimados, sem trânsito em tempo real';
      });
      if (_ready)
        _map.fitCamera(
          CameraFit.coordinates(
            coordinates: route.points,
            padding: const EdgeInsets.all(30),
          ),
        );
    } catch (_) {
      if (mounted && token == _request)
        setState(
          () => _routeStatus =
              'Não foi possível calcular a rota. Use Abrir navegação.',
        );
    } finally {
      if (mounted && token == _request) setState(() => _routing = false);
    }
  }

  Future<void> _navigate(Hospital hospital) async {
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${hospital.latitude},${hospital.longitude}',
      'travelmode': 'driving',
      if (_userLat != null && _userLng != null) 'origin': '$_userLat,$_userLng',
    });
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir a navegação.')),
      );
  }

  Widget _interactiveMap(List<Hospital> hospitals) {
    if (!_enabled)
      return SizedBox(
        height: 150,
        child: Center(
          child: OutlinedButton.icon(
            onPressed: _fetchLocation,
            icon: const Icon(Icons.map_outlined),
            label: const Text('Ativar mapa e GPS'),
          ),
        ),
      );
    return SizedBox(
      height: (MediaQuery.sizeOf(context).height * 0.28)
          .clamp(110.0, 210.0)
          .toDouble(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: const LatLng(-14.2, -51.9),
            initialZoom: 3,
            onMapReady: () {
              _ready = true;
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'br.edu.toxid',
              tileProvider: _tiles!,
              errorTileCallback: (_, error, stack) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted &&
                      !_locationStatus.startsWith('Mapa indisponível'))
                    setState(
                      () => _locationStatus = 'Mapa indisponível. Confira a internet; os cadastros continuam acessíveis.',
                    );
                });
              },
            ),
            if (_route != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _route!.points,
                    color: Colors.blue,
                    strokeWidth: 5,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (_userLat != null && _userLng != null)
                  Marker(
                    point: LatLng(_userLat!, _userLng!),
                    width: 32,
                    height: 32,
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ...hospitals.map(
                  (h) => Marker(
                    point: LatLng(h.latitude, h.longitude),
                    width: 40,
                    height: 40,
                    child: IconButton(
                      tooltip: h.name,
                      onPressed: () => _select(h),
                      icon: Icon(
                        Icons.local_hospital,
                        color: _selected?.id == h.id
                            ? Colors.orange
                            : AppTheme.callGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:192');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospitalService = Provider.of<HospitalService>(context);
    final nearbyHospitals = hospitalsWithRegisteredSerum(
      hospitalService.hospitals, requiredSerum: widget.requiredSerum,
    )
      ..removeWhere(
        (h) =>
            !h.latitude.isFinite ||
            !h.longitude.isFinite ||
            h.latitude.abs() > 90 ||
            h.longitude.abs() > 180 ||
            (h.latitude == 0 && h.longitude == 0),
      );
    if (_userLat != null && _userLng != null)
      nearbyHospitals.sort(
        (a, b) => a
            .distanceFrom(_userLat!, _userLng!)
            .compareTo(b.distanceFrom(_userLat!, _userLng!)),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitais de Referência'),
        actions: [
          IconButton(
            tooltip: 'Atualizar GPS',
            icon: _isLocating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryGreen,
                    ),
                  )
                : const Icon(Icons.my_location, color: AppTheme.primaryGreen),
            onPressed: _isLocating ? null : _fetchLocation,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Banner de status da geolocalização (LGPD Informativo)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppTheme.surfaceColor,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _locationStatus,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (widget.requiredSerum != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warningOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: Text(
                        widget.requiredSerum!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.warningOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _interactiveMap(nearbyHospitals),
                  if (_enabled)
                    InkWell(
                      onTap: () => launchUrl(
                        Uri.parse('https://www.openstreetmap.org/copyright'),
                      ),
                      child: const Text(
                        '© OpenStreetMap contributors • hospitais do cadastro ToxID',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  if (_selected != null)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _selected!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _routeStatus,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: _routing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              tooltip: 'Abrir navegação',
                              onPressed: () => _navigate(_selected!),
                              icon: const Icon(Icons.directions),
                            ),
                    ),
                ],
              ),
            ),
            // Lista de Hospitais
            Expanded(
              child: hospitalService.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryGreen,
                      ),
                    )
                  : nearbyHospitals.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma unidade com soro cadastrado corresponde à seleção. Consulte o atendimento de emergência pelo 192.',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: nearbyHospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = nearbyHospitals[index];
                        return HospitalCard(
                          hospital: hospital,
                          userLat: _userLat,
                          userLng: _userLng,
                          onRoute: () => _select(hospital),
                          onNavigate: () => _navigate(hospital),
                        );
                      },
                    ),
            ),

            // Botão Fixo de Emergência (SAMU 192)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.darkBackground,
                border: Border(top: BorderSide(color: AppTheme.borderColor)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _callEmergency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.callGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.phone_in_talk, color: Colors.white),
                  label: const Text(
                    'Ligue Agora (SAMU 192)',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

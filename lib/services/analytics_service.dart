import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsService {
  Future<void> _log(String name, [Map<String, Object>? parameters]) async {
    if (Firebase.apps.isEmpty) return;
    try { await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters); }
    catch (_) { /* A telemetria não interrompe a emergência. */ }
  }
  void logSpeciesViewed(String speciesId) => _log('species_viewed', {'species_id': speciesId});
  void logTriageStarted() => _log('triage_started');
  void logTriageCompleted({required String speciesId, required String speciesName, required String antivenom}) =>
      _log('triage_completed', {'species_id': speciesId});
  void logHospitalViewed(String hospitalName) => _log('hospital_viewed');
  void logEmergencyCall(String target) => _log('emergency_call');
  void logEmergencyShare(String speciesName) => _log('emergency_share');
}

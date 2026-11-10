/// Modelos para a Árvore de Decisão Rápida do Modo Emergência
class TriageOption {
  final String label;
  final String? subtitle;
  final String? iconName;
  final String? nextStepId;
  final String? resultSpeciesId;

  const TriageOption({
    required this.label,
    this.subtitle,
    this.iconName,
    this.nextStepId,
    this.resultSpeciesId,
  });
}

class TriageStep {
  final String id;
  final String title;
  final String subtitle;
  final List<TriageOption> options;

  const TriageStep({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.options,
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/species.dart';
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

  String _category = 'Reptiles';
  String _dangerLevel = 'Muy Peligrosa';
  bool _isSaving = false;

  final List<String> _categories = ['Reptiles', 'Arácnidos', 'Anfibios', 'Insectos'];
  final List<String> _dangerLevels = ['Muy Peligrosa', 'Peligrosa', 'Bajo Peligro', 'No Peligrosa'];

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
    _colorsCtrl = TextEditingController(text: s?.colors.join(', ') ?? '');
    _characteristicsCtrl = TextEditingController(text: s?.characteristics.join(', ') ?? '');

    if (s != null) {
      if (_categories.contains(s.category)) _category = s.category;
      if (_dangerLevels.contains(s.dangerLevel)) _dangerLevel = s.dangerLevel;
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
      imageUrl: _imageCtrl.text.trim().isNotEmpty
          ? _imageCtrl.text.trim()
          : 'https://images.unsplash.com/photo-1531386151447-fd76ad50012f?auto=format&fit=crop&w=600&q=80',
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

    setState(() => _isSaving = false);

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
                    hintText: 'Marrom, Amarelo, Negro',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _characteristicsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Características Marcantes (para triagem)',
                    hintText: 'Tiene Cascabel, Tenía manchas o rombos',
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
                  decoration: const InputDecoration(
                    labelText: 'URL da Imagem ou Caminho Asset',
                    hintText: 'https://... ou assets/images/...',
                  ),
                ),
                const SizedBox(height: 14),
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

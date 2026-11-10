import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hospital.dart';
import '../../domain/hospital_coordinates.dart';
import '../../services/hospital_service.dart';
import '../../theme/app_theme.dart';

/// Formulário de Cadastro e Edição de Hospitais (CRUD - Create & Update).
class HospitalFormScreen extends StatefulWidget {
  final Hospital? hospitalToEdit;

  const HospitalFormScreen({super.key, this.hospitalToEdit});

  @override
  State<HospitalFormScreen> createState() => _HospitalFormScreenState();
}

class _HospitalFormScreenState extends State<HospitalFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _latCtrl;
  late TextEditingController _lngCtrl;
  late TextEditingController _serumsCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final h = widget.hospitalToEdit;
    _nameCtrl = TextEditingController(text: h?.name ?? '');
    _stateCtrl = TextEditingController(text: h?.state ?? 'Goiás');
    _cityCtrl = TextEditingController(text: h?.city ?? 'Goiânia');
    _addressCtrl = TextEditingController(text: h?.address ?? '');
    _phoneCtrl = TextEditingController(text: h?.phone ?? '');
    _latCtrl = TextEditingController(text: h != null ? h.latitude.toString() : '');
    _lngCtrl = TextEditingController(text: h != null ? h.longitude.toString() : '');
    _serumsCtrl = TextEditingController(text: h?.availableSerums.join(', ') ?? 'SAB, SAC, SAEsc');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _stateCtrl.dispose();
    _cityCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _serumsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final service = Provider.of<HospitalService>(context, listen: false);

    final serumsList = _serumsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final newOrUpdated = Hospital(
      id: widget.hospitalToEdit?.id ?? '',
      name: _nameCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      latitude: parseHospitalCoordinate(_latCtrl.text)!,
      longitude: parseHospitalCoordinate(_lngCtrl.text)!,
      emergencyPhone: widget.hospitalToEdit?.emergencyPhone ?? '192',
      availableSerums: serumsList,
    );

    bool ok;
    if (widget.hospitalToEdit == null) {
      ok = await service.createHospital(newOrUpdated);
    } else {
      ok = await service.updateHospital(newOrUpdated);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(service.errorMessage ?? 'Não foi possível salvar. Tente novamente.'),
      ));
      return;
    }

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.hospitalToEdit == null
              ? 'Hospital adicionado com sucesso!'
              : 'Hospital atualizado com sucesso!'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.hospitalToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Hospital' : 'Novo Hospital'),
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
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nome do Hospital / Unidade *'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(labelText: 'Cidade *'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _stateCtrl,
                        decoration: const InputDecoration(labelText: 'Estado *'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: const InputDecoration(labelText: 'Endereço Completo *'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Telefone de Contato / Emergência *',
                    hintText: '(62) 3201-4300',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o telefone' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(labelText: 'Latitude', helperText: 'Aceita ponto ou vírgula', helperMaxLines: 2),
                        validator: (v) => validateHospitalCoordinate(v, latitude: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lngCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(labelText: 'Longitude', helperText: 'Aceita ponto ou vírgula', helperMaxLines: 2),
                        validator: (v) => validateHospitalCoordinate(v, latitude: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _serumsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Soros Disponíveis (separados por vírgula)',
                    hintText: 'SAB, SAC, SAEsc, SAAr',
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
                      : Text(isEditing ? 'Atualizar Hospital' : 'Salvar Novo Hospital',
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

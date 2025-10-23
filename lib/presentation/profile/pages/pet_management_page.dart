import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../bloc/profile_bloc.dart';

class PetManagementPage extends StatefulWidget {
  final Pet? pet;

  const PetManagementPage({super.key, this.pet});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  late String _selectedType;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _weightController = TextEditingController(text: widget.pet?.weight.toString() ?? '');
    _selectedType = widget.pet?.type ?? 'Dog';
    _selectedDate = widget.pet?.birthDate ?? DateTime.now().subtract(const Duration(days: 365));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      final pet = Pet(
        id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        breed: _breedController.text,
        birthDate: _selectedDate,
        weight: double.parse(_weightController.text),
      );

      if (widget.pet != null) {
        context.read<ProfileBloc>().add(EditPetEvent(pet));
      } else {
        context.read<ProfileBloc>().add(AddPetEvent(pet));
      }

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet != null ? 'Edit Pet' : 'Add New Pet'),
        actions: [
          TextButton(
            onPressed: _savePet,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Pet Image
              GestureDetector(
                onTap: () {
                  // TODO: Implement image picker
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    _getPetIcon(_selectedType),
                    size: 40,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Pet Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pet Type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Pet Type',
                  prefixIcon: Icon(Icons.emoji_nature),
                ),
                items: ['Dog', 'Cat', 'Other'].map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Breed
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  prefixIcon: Icon(Icons.agriculture),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter breed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Birth Date
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Birth Date',
                      prefixIcon: Icon(Icons.cake),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select birth date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPetIcon(String type) {
    switch (type) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.cruelty_free;
      default:
        return Icons.emoji_nature;
    }
  }
}
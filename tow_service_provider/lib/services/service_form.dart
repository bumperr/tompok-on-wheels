import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/models/service.dart';
import 'package:tow_service_provider/routes.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ServiceForm extends StatefulWidget {
  final bool isEditing;
  final String? serviceId;

  const ServiceForm({
    Key? key,
    required this.isEditing,
    this.serviceId,
  }) : super(key: key);

  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationHoursController = TextEditingController();
  final _durationMinutesController = TextEditingController();
  final _capacityController = TextEditingController();

  String _category = 'grooming';
  bool _isPricePerDay = false;
  bool _isPremium = false;
  bool _isActive = true;
  List<String> _selectedPetTypes = ['Cat'];
  List<String> _selectedPetSizes = ['All'];

  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasImage = false;
  String? _imagePath;
  FilePickerResult? _pickedImage;

  // Sample service for edit mode
  final Service _sampleService = Service(
    id: 's001',
    providerId: 'sp001',
    name: 'Basic Grooming',
    description:
        'Basic grooming service including bathing, brushing, nail trimming, and ear cleaning.',
    category: 'grooming',
    price: 80.00,
    duration: 60,
    petTypes: ['Cat'],
    imageUrl:
        'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  );

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadServiceData();
    } else {
      // Set defaults for new service
      _durationHoursController.text = '1';
      _durationMinutesController.text = '0';
      _capacityController.text = '5';
    }
  }

  Future<void> _loadServiceData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would fetch the service from an API
      // For this demo, we'll use the sample service
      await Future.delayed(const Duration(milliseconds: 500));

      final service = _sampleService;

      _nameController.text = service.name;
      _descriptionController.text = service.description;
      _priceController.text = service.price.toString();
      _category = service.category;
      _isPricePerDay = service.isPricePerDay;
      _isPremium = service.isPremium;
      _isActive = service.isActive;
      _selectedPetTypes = List.from(service.petTypes);
      _selectedPetSizes = List.from(service.petSizes);
      _capacityController.text = (service.capacity).toString();

      // Calculate hours and minutes
      final hours = service.duration ~/ 60;
      final minutes = service.duration % 60;
      _durationHoursController.text = hours.toString();
      _durationMinutesController.text = minutes.toString();

      // Image status
      _hasImage = service.imageUrl != null && service.imageUrl!.isNotEmpty;
      _imagePath = service.imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading service: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationHoursController.dispose();
    _durationMinutesController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _pickedImage = result;
          _hasImage = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Get hours and minutes
      final hours = int.tryParse(_durationHoursController.text) ?? 0;
      final minutes = int.tryParse(_durationMinutesController.text) ?? 0;

      // ignore: unused_local_variable
      final totalDuration = (hours * 60) + minutes;

      // In a real app, this would save the service to an API
      // For demo purposes, we'll just show a success message

      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Service updated successfully'
                : 'Service created successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to services list
      Navigator.pushNamed(context, AppRoutes.servicesRoute);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving service: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Service' : 'Add New Service'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _isSaving ? null : _saveService,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Image
                        _buildImageSection(),
                        const SizedBox(height: 32),

                        // Basic Information
                        _buildBasicInfoSection(),
                        const SizedBox(height: 32),

                        // Pricing and Duration
                        _buildPricingSection(),
                        const SizedBox(height: 32),

                        // Pet Types and Sizes
                        _buildPetOptionsSection(),
                        const SizedBox(height: 32),

                        // Additional Options
                        _buildAdditionalOptionsSection(),
                        const SizedBox(height: 32),

                        // Action Buttons
                        _buildActionButtons(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Image',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: _selectImage,
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                image: _pickedImage != null
                    ? null // We'll handle picked image separately
                    : _hasImage && _imagePath != null
                        ? DecorationImage(
                            image: NetworkImage(_imagePath!),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: _pickedImage != null
                  ? kIsWeb
                      ? Image.memory(
                          _pickedImage!.files.first.bytes!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.grey,
                        )
                  : !_hasImage
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Click to add image',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : null,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            icon: const Icon(Icons.add_photo_alternate),
            label: Text(_hasImage ? 'Change Image' : 'Add Image'),
            onPressed: _selectImage,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Service Name',
            hintText: 'Enter service name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a service name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items: kServiceCategories.map((String value) {
            return DropdownMenuItem<String>(
              value: value.toLowerCase(),
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _category = value!;

              // Auto-set price per day for boarding
              if (value == 'boarding') {
                _isPricePerDay = true;
              } else {
                _isPricePerDay = false;
              }
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Enter service description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing and Duration',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Field
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  hintText: 'Enter price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),

            // Price Per Day Toggle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pricing Type',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Switch(
                      value: _isPricePerDay,
                      onChanged: (value) {
                        setState(() {
                          _isPricePerDay = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(_isPricePerDay ? 'Price per day' : 'Fixed price'),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Duration Fields
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Duration',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Hours
                      Expanded(
                        child: TextFormField(
                          controller: _durationHoursController,
                          decoration: const InputDecoration(
                            labelText: 'Hours',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Minutes
                      Expanded(
                        child: TextFormField(
                          controller: _durationMinutesController,
                          decoration: const InputDecoration(
                            labelText: 'Minutes',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final minutes = int.tryParse(value);
                            if (minutes == null) {
                              return 'Invalid';
                            }
                            if (minutes < 0 || minutes > 59) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Capacity
            Expanded(
              child: TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Max Pets Per Day',
                  hintText: 'Enter capacity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Must be > 0';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPetOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pet Types and Sizes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Pet Types
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pet Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip(
                  label: 'Cat',
                  isSelected: _selectedPetTypes.contains('Cat'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetTypes.add('Cat');
                      } else {
                        _selectedPetTypes.remove('Cat');
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Dog',
                  isSelected: _selectedPetTypes.contains('Dog'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetTypes.add('Dog');
                      } else {
                        _selectedPetTypes.remove('Dog');
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Rabbit',
                  isSelected: _selectedPetTypes.contains('Rabbit'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetTypes.add('Rabbit');
                      } else {
                        _selectedPetTypes.remove('Rabbit');
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Bird',
                  isSelected: _selectedPetTypes.contains('Bird'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetTypes.add('Bird');
                      } else {
                        _selectedPetTypes.remove('Bird');
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Other',
                  isSelected: _selectedPetTypes.contains('Other'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetTypes.add('Other');
                      } else {
                        _selectedPetTypes.remove('Other');
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'All',
                  isSelected: _selectedPetTypes.contains('All'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetTypes = ['All'];
                      } else {
                        _selectedPetTypes.remove('All');
                        if (_selectedPetTypes.isEmpty) {
                          _selectedPetTypes.add('Cat');
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Pet Sizes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pet Sizes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip(
                  label: 'Small',
                  isSelected: _selectedPetSizes.contains('Small'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetSizes.add('Small');
                        _selectedPetSizes.remove('All');
                      } else {
                        _selectedPetSizes.remove('Small');
                        if (_selectedPetSizes.isEmpty) {
                          _selectedPetSizes.add('All');
                        }
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Medium',
                  isSelected: _selectedPetSizes.contains('Medium'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetSizes.add('Medium');
                        _selectedPetSizes.remove('All');
                      } else {
                        _selectedPetSizes.remove('Medium');
                        if (_selectedPetSizes.isEmpty) {
                          _selectedPetSizes.add('All');
                        }
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Large',
                  isSelected: _selectedPetSizes.contains('Large'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetSizes.add('Large');
                        _selectedPetSizes.remove('All');
                      } else {
                        _selectedPetSizes.remove('Large');
                        if (_selectedPetSizes.isEmpty) {
                          _selectedPetSizes.add('All');
                        }
                      }
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'All',
                  isSelected: _selectedPetSizes.contains('All'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetSizes = ['All'];
                      } else {
                        _selectedPetSizes.remove('All');
                        if (_selectedPetSizes.isEmpty) {
                          _selectedPetSizes.add('Small');
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Premium toggle
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: _isPremium,
                    onChanged: (value) {
                      setState(() {
                        _isPremium = value;
                      });
                    },
                    activeColor: kPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Premium Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mark as a premium service',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Active toggle
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                    activeColor: kPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Service Active',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Service is available for booking',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: Text(_isSaving ? 'Saving...' : 'Save Service'),
          onPressed: _isSaving ? null : _saveService,
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: kPrimaryColor.withOpacity(0.2),
      checkmarkColor: kPrimaryColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddPetScreen extends StatefulWidget {
  final Function(Pet) onPetAdded;

  const AddPetScreen({
    Key? key,
    required this.onPetAdded,
  }) : super(key: key);

  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _name = '';
  String _breed = '';
  int _age = 0;
  double _weight = 0.0;
  String _size = 'Medium';
  String _imageUrl = '';
  File? _imageFile;
  String _notes = '';

  List<String> _sizeOptions = ['Small', 'Medium', 'Large'];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // For demo purposes, we'll use a placeholder URL if no image is selected
      // In a real app, you would upload the image to storage and get the URL
      if (_imageFile == null && _imageUrl.isEmpty) {
        _imageUrl = 'https://example.com/placeholder_pet.jpg';
      }

      // Create the new pet
      final newPet = Pet(
        name: _name,
        breed: _breed,
        age: _age,
        weight: _weight,
        size: _size,
        imageUrl: _imageUrl,
        notes: [], // Empty notes list initially
      );

      // Call the callback to add the pet
      widget.onPetAdded(newPet);

      // Navigate back
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Pet'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet Image Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : AssetImage('assets/images/pet_placeholder.png'),
                        child: _imageFile == null
                            ? const Icon(Icons.pets, size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _showImageSourceActionSheet,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Pet Name
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pet Name*',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pet\'s name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Pet Breed
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Breed*',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pet\'s breed';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _breed = value!;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Row for Age and Weight
                Row(
                  children: [
                    // Age
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Age (years)*',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Enter a number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _age = int.parse(value!);
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Weight
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)*',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _weight = double.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Size Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.height),
                  ),
                  value: _size,
                  items: _sizeOptions.map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _size = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Additional Notes
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  onSaved: (value) {
                    _notes = value ?? '';
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Add Pet',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
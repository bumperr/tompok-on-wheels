import 'package:flutter/material.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PetDetailsScreen extends StatefulWidget {
  final Pet pet;
  final Function(Pet) onPetUpdated;

  const PetDetailsScreen({
    Key? key,
    required this.pet,
    required this.onPetUpdated,
  }) : super(key: key);

  @override
  _PetDetailsScreenState createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Pet _currentPet;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentPet = widget.pet;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          // In a real app, you would upload this file and get a URL
          // For now, we'll just update the local state
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

  void _showAddNoteDialog() {
    String title = '';
    String description = '';
    DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now().replacing(
        hour: (TimeOfDay.now().hour + 1) % 24);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Note'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ListTile(
                      title: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('Start Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ListTile(
                      title: Text(startTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (picked != null && picked != startTime) {
                          setState(() {
                            startTime = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('End Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ListTile(
                      title: Text(endTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (picked != null && picked != endTime) {
                          setState(() {
                            endTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  onPressed: () {
                    if (title.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    // Create DateTime objects for start and end times
                    final startDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      startTime.hour,
                      startTime.minute,
                    );
                    final endDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      endTime.hour,
                      endTime.minute,
                    );

                    // Create a new note using the Note class from Pet.dart
                    Note newNote = Note(
                      title: title,
                      description: description,
                      startDateTime: startDateTime,
                      endDateTime: endDateTime,
                    );

                    setState(() {
                      _currentPet.notes.add(newNote);
                      widget.onPetUpdated(_currentPet);
                    });
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Note added successfully!')),
                    );
                  },
                  child: const Text('Add Note'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditPetInfoDialog() {
    String name = _currentPet.name;
    String breed = _currentPet.breed;
    int age = _currentPet.age;
    double weight = _currentPet.weight;
    String size = _currentPet.size;
    
    final _formKey = GlobalKey<FormState>();
    final List<String> _sizeOptions = ['Small', 'Medium', 'Large'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Pet Information'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: breed,
                    decoration: const InputDecoration(
                      labelText: 'Breed',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a breed';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      breed = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: age.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
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
                            age = int.parse(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: weight.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
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
                            weight = double.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                    value: size,
                    items: _sizeOptions.map((size) {
                      return DropdownMenuItem(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    onChanged: (value) {
                      size = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  
                  setState(() {
                    _currentPet = Pet(
                      name: name,
                      breed: breed,
                      age: age,
                      weight: weight,
                      size: size,
                      imageUrl: _currentPet.imageUrl,
                      notes: _currentPet.notes,
                    );
                    widget.onPetUpdated(_currentPet);
                  });
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pet information updated successfully!')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPet.name),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditPetInfoDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Info', icon: Icon(Icons.info)),
            Tab(text: 'Notes', icon: Icon(Icons.note)),
            Tab(text: 'Health', icon: Icon(Icons.favorite)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          if (_tabController.index == 1) {
            _showAddNoteDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please go to the Notes tab to add a note')),
            );
          }
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildNotesTab(),
          _buildHealthTab(),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet Image Section
          Center(
            child: Stack(
              children: [
                Hero(
                  tag: 'pet_${_currentPet.name}',
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : NetworkImage(_currentPet.imageUrl),
                  ),
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
          
          // Pet Information Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildInfoRow('Name', _currentPet.name),
                  _buildInfoRow('Breed', _currentPet.breed),
                  _buildInfoRow('Age', '${_currentPet.age} years'),
                  _buildInfoRow('Weight', '${_currentPet.weight} kg'),
                  _buildInfoRow('Size', _currentPet.size),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Recommendations Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pet Care Recommendations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.pets, color: kPrimaryColor),
                    title: const Text('Regular Exercise'),
                    subtitle: Text(
                      _currentPet.size == 'Small' 
                          ? 'At least 30 minutes of play daily'
                          : _currentPet.size == 'Medium'
                              ? 'At least a 1-hour walk daily'
                              : 'At least 2 hours of exercise daily'
                    ),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.restaurant, color: kPrimaryColor),
                    title: const Text('Feeding Schedule'),
                    subtitle: Text(
                      _currentPet.size == 'Small' 
                          ? '2-3 small meals per day'
                          : _currentPet.size == 'Medium'
                              ? '2 meals per day'
                              : '2-3 meals per day with proper portioning'
                    ),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.medical_services, color: kPrimaryColor),
                    title: const Text('Veterinary Checkup'),
                    subtitle: const Text('Every 6 months for routine examination'),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.brush, color: kPrimaryColor),
                    title: const Text('Grooming Needs'),
                    subtitle: Text(
                      _currentPet.breed.toLowerCase().contains('long') 
                          ? 'Brushing 2-3 times per week, bath every 4-6 weeks'
                          : 'Brushing once a week, bath every 6-8 weeks'
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    if (_currentPet.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No notes yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a note',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _currentPet.notes.length,
      itemBuilder: (context, index) {
        final note = _currentPet.notes[index];
        // startDateTime and endDateTime are already DateTime objects
        final startDateTime = note.startDateTime;
        final endDateTime = note.endDateTime;
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            // Edit note functionality would go here
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Note'),
                                content: const Text('Are you sure you want to delete this note?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _currentPet.notes.removeAt(index);
                                        widget.onPetUpdated(_currentPet);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                
                const Divider(),
                
                Text(
                  note.description,
                  style: const TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(startDateTime),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat.jm().format(startDateTime)} - ${DateFormat.jm().format(endDateTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vaccination Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vaccination Records',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: kPrimaryColor,
                        onPressed: () {
                          // Add vaccination record functionality
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Sample vaccination records
                  _buildVaccinationRecord(
                    'FVRCP Vaccine',
                    'Apr 15, 2023',
                    'Due: Apr 15, 2024',
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildVaccinationRecord(
                    'Rabies Vaccine',
                    'Jun 10, 2023',
                    'Due: Jun 10, 2025',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Medical History Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Medical History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: kPrimaryColor,
                        onPressed: () {
                          // Add medical record functionality
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Sample medical records
                  _buildMedicalRecord(
                    'Annual Checkup',
                    'Dec 05, 2023',
                    'Regular health examination. All vitals normal.',
                    'Dr. Ahmad, Happy Paws Veterinary Clinic',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildMedicalRecord(
                    'Dental Cleaning',
                    'Aug 18, 2023',
                    'Routine dental cleaning and examination.',
                    'Dr. Lee, Seri Iskandar Animal Hospital',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Weight History Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weight History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: kPrimaryColor,
                        onPressed: () {
                          // Add weight record functionality
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Sample weight chart
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Weight chart will be displayed here',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  
                  // Sample weight records
                  ListTile(
                    title: const Text('Latest Weight'),
                    subtitle: Text('${_currentPet.weight} kg (Today)'),
                    trailing: const Icon(Icons.trending_up, color: Colors.green),
                  ),
                  
                  ListTile(
                    title: const Text('6 Months Ago'),
                    subtitle: const Text('4.8 kg (Sep 15, 2023)'),
                    trailing: const Icon(Icons.trending_flat, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationRecord(String name, String date, String dueDate) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: $date'),
          Text(dueDate, style: const TextStyle(color: Colors.red)),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          // Show more options
        },
      ),
    );
  }

  Widget _buildMedicalRecord(String title, String date, String description, String provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              date,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(description),
        const SizedBox(height: 4),
        Text(
          provider,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
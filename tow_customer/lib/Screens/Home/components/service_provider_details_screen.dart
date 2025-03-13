import 'package:flutter/material.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/constants.dart';
import 'package:intl/intl.dart';
import 'package:tow_customer/Screens/Payment/payment_page.dart';

class ServiceProviderDetailsScreen extends StatefulWidget {
  final ServiceProvider serviceProvider;
  final List<Pet> pets;
  final Function(Booking)? onBookingAdded;
  final String userId;
  final List<Service>? services;

  const ServiceProviderDetailsScreen({
    Key? key,
    required this.serviceProvider,
    required this.pets,
    required this.userId,
    this.onBookingAdded,
    this.services,
  }) : super(key: key);

  @override
  _ServiceProviderDetailsScreenState createState() =>
      _ServiceProviderDetailsScreenState();
}

class _ServiceProviderDetailsScreenState
    extends State<ServiceProviderDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  int selectedTimeSlotIndex = -1;
  String? selectedPetId;
  String? selectedServiceId;
  bool isBoardingService = false;
  int numberOfDays = 1;
  double servicePrice = 0.0;
  double totalPrice = 0.0;
  bool includeInsurance = false; // Add this line for insurance option
  // Sample data for services if not provided
  late List<Service> _services;

  // ScrollController to track scroll position for app bar title visibility
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Add scroll listener to show/hide title based on scroll position
    _scrollController.addListener(() {
      final showTitle = _scrollController.offset > 50;
      if (showTitle != _showTitle) {
        setState(() {
          _showTitle = showTitle;
        });
      }
    });

    if (widget.services != null) {
      _services = widget.services!;
    } else {
      // Default sample services
      _services = [
        Service(
          id: 's001',
          name: 'Basic Health Check',
          description:
              'General health assessment including temperature, weight, heart rate, and visual examination.',
          category: 'veterinary',
          price: 80.00,
          duration: 30,
        ),
        Service(
          id: 's002',
          name: 'Vaccination',
          description:
              'Administration of core vaccines to protect against common diseases.',
          category: 'veterinary',
          price: 120.00,
          duration: 15,
        ),
        Service(
          id: 's003',
          name: 'Dental Cleaning',
          description:
              'Professional cleaning to remove plaque and tartar from teeth.',
          category: 'veterinary',
          price: 250.00,
          duration: 60,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Generate time slots for the selected date
  List<TimeOfDay> getTimeSlots() {
    List<TimeOfDay> slots = [];

    // For weekdays (Monday-Friday)
    if (selectedDate.weekday >= 1 && selectedDate.weekday <= 5) {
      // Morning slots: 9:00 AM to 12:00 PM
      for (int hour = 9; hour <= 12; hour++) {
        slots.add(TimeOfDay(hour: hour, minute: 0));
        if (hour != 12) {
          // Don't add 12:30
          slots.add(TimeOfDay(hour: hour, minute: 30));
        }
      }

      // Afternoon slots: 2:00 PM to 5:30 PM
      for (int hour = 14; hour <= 17; hour++) {
        slots.add(TimeOfDay(hour: hour, minute: 0));
        if (hour != 17) {
          // Don't add 5:30 PM
          slots.add(TimeOfDay(hour: hour, minute: 30));
        }
      }
    }
    // For weekends (Saturday)
    else if (selectedDate.weekday == 6) {
      // Morning slots only: 9:00 AM to 1:00 PM
      for (int hour = 9; hour <= 13; hour++) {
        slots.add(TimeOfDay(hour: hour, minute: 0));
        if (hour != 13) {
          // Don't add 1:30 PM
          slots.add(TimeOfDay(hour: hour, minute: 30));
        }
      }
    }
    // Sunday - closed

    return slots;
  }

  void _updateTotalPrice() {
    if (selectedServiceId != null) {
      final selectedService =
          _services.firstWhere((s) => s.id == selectedServiceId);
      servicePrice = selectedService.price;

      double basePrice = isBoardingService && selectedService.isPricePerDay
          ? servicePrice * numberOfDays
          : servicePrice;

      double distanceFee =
          (widget.serviceProvider.distance ?? 0) * 5.0; // 3 RM per KM
      double subtotal = basePrice + distanceFee;
      double serviceCharge = subtotal + 30; // 6% service charge
      totalPrice = subtotal + serviceCharge + (includeInsurance ? 5.0 : 0.0);
    }
  }

  bool _canProceedToBooking() {
    if (selectedPetId == null || selectedServiceId == null) {
      return false;
    }

    if (isBoardingService) {
      return true; // For boarding, we just need pet, service, and dates
    } else {
      return selectedTimeSlotIndex >=
          0; // For other services, we need a time slot
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              title: _showTitle
                  ? Text(
                      widget.serviceProvider.name,
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    )
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                title: !_showTitle
                    ? Text(
                        widget.serviceProvider.name,
                        style: const TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      )
                    : null,
                titlePadding:
                    const EdgeInsetsDirectional.only(start: 16, bottom: 80),
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.serviceProvider.logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.business,
                              size: 80, color: Colors.grey),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha((0.3 * 255).toInt()),
                            Colors.black.withAlpha((0.7 * 255).toInt()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(
                    text: 'Services',
                    icon: Icon(Icons.medical_services, color: Colors.white),
                  ),
                  Tab(
                    text: 'Booking',
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  Tab(
                    text: 'Reviews',
                    icon: Icon(Icons.star_rate, color: Colors.white),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    widget.serviceProvider.isVerified
                        ? Icons.verified
                        : Icons.verified_outlined,
                    color: widget.serviceProvider.isVerified
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.serviceProvider.isVerified
                              ? 'This service provider is verified'
                              : 'This service provider is not verified yet',
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Share functionality
                  },
                ),
              ],
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildServicesTab(),
            _buildBookingTab(),
            _buildReviewsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    // Group services by category
    Map<String, List<Service>> servicesByCategory = {};

    for (var service in _services) {
      if (!servicesByCategory.containsKey(service.category)) {
        servicesByCategory[service.category] = [];
      }
      servicesByCategory[service.category]!.add(service);
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider Info Card
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
                    'About Provider',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.category, color: kPrimaryColor),
                    title: const Text('Category'),
                    subtitle: Text(widget.serviceProvider.category),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text('Rating'),
                    subtitle: Text(
                        '${widget.serviceProvider.rating} (${_services.length} reviews)'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    title: const Text('Location'),
                    subtitle: Text(
                        '${widget.serviceProvider.distance} km away (${widget.serviceProvider.travelTime} min travel time)'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const ListTile(
                    leading: Icon(Icons.access_time, color: Colors.orange),
                    title: Text('Business Hours'),
                    subtitle: Text(
                        'Monday - Friday: 9:00 AM - 6:00 PM\nSaturday: 9:00 AM - 1:00 PM\nSunday: Closed'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Services List by Category
          ...servicesByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key.substring(0, 1).toUpperCase()}${entry.key.substring(1)} Services',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...entry.value
                    .map((service) => _buildServiceCard(service))
                    .toList(),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            service.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        subtitle: Text(
          'RM ${service.price.toStringAsFixed(2)}${service.isPricePerDay ? '/day' : ''} · ${service.duration < 60 ? '${service.duration} min' : '${service.duration ~/ 60} hr${service.duration ~/ 60 > 1 ? 's' : ''}${service.duration % 60 > 0 ? ' ${service.duration % 60} min' : ''}'}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(service.description),
                if (service.isPremium) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber[800], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Premium Service',
                          style: TextStyle(
                            color: Colors.amber[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Pre-select this service and navigate to booking tab
                      setState(() {
                        selectedServiceId = service.id;
                        isBoardingService = service.category == 'boarding' &&
                            service.isPricePerDay;
                        _updateTotalPrice();
                        _tabController.animateTo(1); // Switch to booking tab
                      });
                    },
                    child: const Text('Book This Service'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTab() {
    final timeSlots = getTimeSlots();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet Selection
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
                    'Select Pet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Enhanced pet selection with images
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: widget.pets.map((pet) {
                          final isSelected = pet.id == selectedPetId;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedPetId = pet.id;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? kPrimaryColor
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? kPrimaryColor.withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(
                                      pet.imageUrl.isNotEmpty
                                          ? pet.imageUrl
                                          : 'https://example.com/placeholder_pet.jpg',
                                    ),
                                    backgroundColor: Colors.grey[200],
                                    child: pet.imageUrl.isEmpty
                                        ? const Icon(Icons.pets,
                                            size: 24, color: Colors.grey)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${pet.breed} · ${pet.age} years',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle,
                                        color: kPrimaryColor),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Service Selection
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
                    'Select Service',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Fixed service dropdown to prevent overflow
                  DropdownButtonFormField<String>(
                    isExpanded: true, // This fixes the overflow issue
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    hint: const Text('Choose a service'),
                    value: selectedServiceId,
                    items: _services.map<DropdownMenuItem<String>>((service) {
                      return DropdownMenuItem<String>(
                        value: service.id,
                        child: Text(
                          '${service.name} - RM ${service.price.toStringAsFixed(2)}${service.isPricePerDay ? '/day' : ''}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedServiceId = value;
                        // Check if boarding service is selected
                        if (value != null) {
                          final selectedService =
                              _services.firstWhere((s) => s.id == value);
                          isBoardingService =
                              selectedService.category == 'boarding' &&
                                  selectedService.isPricePerDay;
                          _updateTotalPrice();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Boarding days selection (only show if boarding service is selected)
          if (isBoardingService) ...[
            const SizedBox(height: 20),
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
                      'Number of Days',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: numberOfDays > 1
                              ? () {
                                  setState(() {
                                    numberOfDays--;
                                    _updateTotalPrice();
                                  });
                                }
                              : null,
                        ),
                        Expanded(
                          child: Text(
                            numberOfDays.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              numberOfDays++;
                              _updateTotalPrice();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Date Selection
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
                    'Select Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Calendar
                  CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                    onDateChanged: (date) {
                      setState(() {
                        selectedDate = date;
                        selectedTimeSlotIndex =
                            -1; // Reset time slot when date changes
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Time Slot Selection (only show if not boarding service)
          if (!isBoardingService)
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
                    Text(
                      'Available Time Slots for ${DateFormat('EEEE, MMMM d').format(selectedDate)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Check if it's Sunday or no slots available
                    if (selectedDate.weekday == 7)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Closed on Sundays',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    else if (timeSlots.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No available time slots for this date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: List.generate(timeSlots.length, (index) {
                          final timeSlot = timeSlots[index];
                          final isSelected = index == selectedTimeSlotIndex;

                          return ChoiceChip(
                            label: Text(timeSlot.format(context)),
                            selected: isSelected,
                            selectedColor: kPrimaryColor,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                selectedTimeSlotIndex = selected ? index : -1;
                              });
                            },
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Price summary
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
                    'Price Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Service Fee'),
                      Text(
                          'RM ${servicePrice.toStringAsFixed(2)}${isBoardingService ? '/day' : ''}'),
                    ],
                  ),
                  if (isBoardingService) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Number of Days'),
                        Text('$numberOfDays days'),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Distance Fee (RM 5/km)'),
                      Text(
                          'RM ${(widget.serviceProvider.distance != null ? widget.serviceProvider.distance! * 3.0 : 0.0).toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Rate (RM 30)'),
                      Text(
                          'RM ${((servicePrice * (isBoardingService ? numberOfDays : 1) + (widget.serviceProvider.distance ?? 0) * 3.0) * 0.06).toStringAsFixed(2)}'),
                    ],
                  ),
                  if (includeInsurance) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Insurance'),
                        const Text('RM 5.00'),
                      ],
                    ),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('RM ${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Insurance (RM 5.00)',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: includeInsurance,
                    onChanged: (value) {
                      setState(() {
                        includeInsurance = value;
                        _updateTotalPrice();
                      });
                    },
                    activeColor: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _canProceedToBooking()
                  ? () {
                      // Handle booking confirmation
                      _showBookingConfirmDialog();
                    }
                  : null,
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          // Add extra space at the bottom for better scrolling experience
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showBookingConfirmDialog() {
    final timeSlots = getTimeSlots();
    final selectedTimeSlot = !isBoardingService && selectedTimeSlotIndex >= 0
        ? timeSlots[selectedTimeSlotIndex]
        : null;

    final selectedPet =
        widget.pets.firstWhere((pet) => pet.id == selectedPetId);
    final selectedService =
        _services.firstWhere((s) => s.id == selectedServiceId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please review your booking details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Provider info with image
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(widget.serviceProvider.logoUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceProvider.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.serviceProvider.category,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Pet info with image
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        selectedPet.imageUrl.isNotEmpty
                            ? selectedPet.imageUrl
                            : 'https://example.com/placeholder_pet.jpg',
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedPet.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${selectedPet.breed} · ${selectedPet.age} years',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Service details
                Row(
                  children: [
                    const Icon(Icons.medical_services,
                        size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedService.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Date & Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                if (isBoardingService)
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 20, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Duration: $numberOfDays days'),
                    ],
                  )
                else if (selectedTimeSlot != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 20, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Time: ${selectedTimeSlot.format(context)}'),
                    ],
                  ),

                const SizedBox(height: 16),

                // Price
                Row(
                  children: [
                    const Icon(Icons.attach_money,
                        size: 20, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Text(
                  'Note: You can cancel your booking up to 24 hours before the appointment time.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
              onPressed: () async {
                final TimeOfDay endTime;
                if (isBoardingService) {
                  endTime = const TimeOfDay(hour: 17, minute: 0);
                } else if (selectedTimeSlot != null) {
                  final totalMinutes = selectedTimeSlot.hour * 60 +
                      selectedTimeSlot.minute +
                      selectedService.duration;
                  endTime = TimeOfDay(
                      hour: (totalMinutes ~/ 60) % 24,
                      minute: totalMinutes % 60);
                } else {
                  endTime = const TimeOfDay(hour: 0, minute: 0);
                }

                final bookingDetails = {
                  'service': selectedService.name,
                  'provider': widget.serviceProvider.name,
                  'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                  'time': isBoardingService
                      ? '$numberOfDays days'
                      : selectedTimeSlot!.format(context),
                  'distanceFee': (widget.serviceProvider.distance ?? 0) * 3.0,
                  'serviceCharge':
                      (servicePrice * (isBoardingService ? numberOfDays : 1) +
                              (widget.serviceProvider.distance ?? 0) * 3.0) *
                          0.06,
                  'insurance': includeInsurance ? 5.0 : 0.0,
                };

                final paymentResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      bookingDetails: bookingDetails,
                      totalAmount: totalPrice,
                    ),
                  ),
                );

                if (paymentResult == true) {
                  final booking = Booking(
                    id: 'book${DateTime.now().millisecondsSinceEpoch}',
                    userId: widget.userId,
                    petId: selectedPetId!,
                    serviceProviderId: widget.serviceProvider.id,
                    serviceId: selectedServiceId!,
                    date: selectedDate,
                    startTime: isBoardingService
                        ? const TimeOfDay(hour: 9, minute: 0)
                        : timeSlots[selectedTimeSlotIndex],
                    endTime: endTime,
                    status: 'Pending',
                    days: isBoardingService ? numberOfDays : 1,
                    totalPrice: totalPrice,
                  );

                  if (widget.onBookingAdded != null) {
                    widget.onBookingAdded!(booking);
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking confirmed! Payment successful.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Rating Summary Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.serviceProvider.rating}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < widget.serviceProvider.rating!.floor()
                                  ? Icons.star
                                  : index < widget.serviceProvider.rating!
                                      ? Icons.star_half
                                      : Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Based on 56 reviews',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Rating Breakdown (simplified)
                _buildRatingBar('5', 0.8),
                _buildRatingBar('4', 0.15),
                _buildRatingBar('3', 0.05),
                _buildRatingBar('2', 0),
                _buildRatingBar('1', 0),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Write a Review Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.rate_review),
            label: const Text('Write a Review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Show review dialog
              _showAddReviewDialog();
            },
          ),
        ),

        const SizedBox(height: 20),

        // Reviews List (sample data)
        const Text(
          'Recent Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        _buildReviewCard({
          'userName': 'Aminah Rahman',
          'rating': 5.0,
          'comment':
              'Dr. Tan was so gentle with my cat. Very professional service!',
          'date': '2023-12-15',
        }),

        _buildReviewCard({
          'userName': 'Lee Wei Min',
          'rating': 4.5,
          'comment':
              'Excellent care for my dog. The staff was knowledgeable and friendly.',
          'date': '2023-11-28',
        }),

        _buildReviewCard({
          'userName': 'Ahmad Firdaus',
          'rating': 4.0,
          'comment': 'Good service but had to wait a bit longer than expected.',
          'date': '2023-10-10',
        }),
      ],
    );
  }

  Widget _buildRatingBar(String rating, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              rating,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percentage * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = review['rating'] as double;
    final date =
        DateFormat('MMM d, yyyy').format(DateTime.parse(review['date']));

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
                  review['userName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating.floor()
                      ? Icons.star
                      : index < rating
                          ? Icons.star_half
                          : Icons.star_border,
                  color: Colors.amber,
                  size: 18,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(review['comment']),
            if (review['userName'] ==
                'Aminah Rahman') // Just for the first review as an example
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: kPrimaryColor,
                        child: const Icon(Icons.business,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.serviceProvider.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  widget.serviceProvider.isVerified
                                      ? Icons.verified
                                      : Icons.verified_outlined,
                                  size: 16,
                                  color: widget.serviceProvider.isVerified
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Thank you for your kind review! We\'re always happy to provide the best care for your pets.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog() {
    double userRating = 5.0;
    String comment = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Write a Review'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How would you rate your experience?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < userRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              userRating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Share your experience',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Write your review here...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      onChanged: (value) {
                        comment = value;
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
                    if (comment.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please write a review')),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your review!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

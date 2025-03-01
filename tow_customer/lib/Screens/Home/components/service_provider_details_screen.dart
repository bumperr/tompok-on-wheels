import 'package:flutter/material.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/constants.dart';
import 'package:intl/intl.dart';

class ServiceProviderDetailsScreen extends StatefulWidget {
  final ServiceProvider serviceProvider;

  const ServiceProviderDetailsScreen({
    Key? key,
    required this.serviceProvider,
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

  // Sample data - in a real app, this would come from an API
  final List<Map<String, dynamic>> _services = [
    {
      'id': 's001',
      'name': 'Basic Health Check',
      'description':
          'General health assessment including temperature, weight, heart rate, and visual examination.',
      'duration': 30,
      'price': 80.00,
    },
    {
      'id': 's002',
      'name': 'Vaccination',
      'description':
          'Administration of core vaccines to protect against common diseases.',
      'duration': 15,
      'price': 120.00,
    },
    {
      'id': 's003',
      'name': 'Dental Cleaning',
      'description':
          'Professional cleaning to remove plaque and tartar from teeth.',
      'duration': 60,
      'price': 250.00,
    },
    {
      'id': 's004',
      'name': 'Microchipping',
      'description':
          'Implantation of a microchip for permanent identification.',
      'duration': 10,
      'price': 60.00,
    },
    {
      'id': 's005',
      'name': 'Full Grooming',
      'description':
          'Complete grooming service including bath, haircut, nail trimming, and ear cleaning.',
      'duration': 90,
      'price': 150.00,
    },
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      'id': 'r001',
      'userName': 'Aminah Rahman',
      'rating': 5.0,
      'comment':
          'Dr. Tan was so gentle with my cat. Very professional service!',
      'date': '2023-12-15',
    },
    {
      'id': 'r002',
      'userName': 'Lee Wei Min',
      'rating': 4.5,
      'comment':
          'Excellent care for my dog. The staff was knowledgeable and friendly.',
      'date': '2023-11-28',
    },
    {
      'id': 'r003',
      'userName': 'Ahmad Firdaus',
      'rating': 4.0,
      'comment': 'Good service but had to wait a bit longer than expected.',
      'date': '2023-10-10',
    },
    {
      'id': 'r004',
      'userName': 'Kavita Nair',
      'rating': 5.0,
      'comment':
          'Best vet clinic in the area! My pets are always comfortable here.',
      'date': '2023-09-22',
    },
  ];

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.serviceProvider.name),
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
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
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
                tabs: const [
                  Tab(text: 'Services', icon: Icon(Icons.medical_services)),
                  Tab(text: 'Booking', icon: Icon(Icons.calendar_today)),
                  Tab(text: 'Reviews', icon: Icon(Icons.star_rate)),
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
    return SingleChildScrollView(
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
                        '${widget.serviceProvider.rating} (${_reviews.length} reviews)'),
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Open maps for directions
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Services List
          const Text(
            'Available Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ..._services.map((service) => _buildServiceCard(service)).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          service['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'RM ${service['price'].toStringAsFixed(2)} · ${service['duration']} min',
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
                Text(service['description']),
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
                      // Navigate to booking tab with pre-selected service
                      setState(() {
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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    hint: const Text('Choose a service'),
                    items: _services.map<DropdownMenuItem<String>>((service) {
                      return DropdownMenuItem<String>(
                        value: service['id'].toString(),
                        child: Text(
                          '${service['name']} - RM ${service['price'].toStringAsFixed(2)}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle service selection
                    },
                  ),
                ],
              ),
            ),
          ),

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

          // Time Slot Selection
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
                      onPressed: selectedTimeSlotIndex >= 0
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmDialog() {
    final timeSlots = getTimeSlots();
    final selectedTimeSlot =
        selectedTimeSlotIndex >= 0 ? timeSlots[selectedTimeSlotIndex] : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please review your booking details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Provider: ${widget.serviceProvider.name}'),
              Text(
                  'Service: ${_services[0]['name']}'), // Replace with actual selected service
              Text(
                  'Date: ${DateFormat('EEEE, MMMM d, yyyy').format(selectedDate)}'),
              if (selectedTimeSlot != null)
                Text('Time: ${selectedTimeSlot.format(context)}'),
              const SizedBox(height: 12),
              const Text(
                'Note: You can cancel your booking up to 24 hours before the appointment time.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
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
                Navigator.pop(context);
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Booking confirmed! You will receive a confirmation email shortly.'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate back to home
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
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
                        Text(
                          'Based on ${_reviews.length} reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
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

        // Reviews List
        const Text(
          'Recent Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ..._reviews.map((review) => _buildReviewCard(review)).toList(),
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
    final rating = review['rating'];
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
            if (review['id'] ==
                'r001') // Just for the first review as an example
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: kPrimaryColor,
                        child:
                            Icon(Icons.business, color: Colors.white, size: 16),
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

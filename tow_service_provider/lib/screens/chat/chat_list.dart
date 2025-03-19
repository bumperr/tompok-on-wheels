import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  String _searchQuery = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample chat data
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': 'chat1',
      'customerId': 'C001',
      'customerName': 'John Doe',
      'customerImage': 'https://randomuser.me/api/portraits/men/1.jpg',
      'lastMessage': 'Hi, I wanted to ask about my booking tomorrow',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 2,
      'lastSender': 'customer', // customer or provider
    },
    {
      'id': 'chat2',
      'customerId': 'C002',
      'customerName': 'Jane Smith',
      'customerImage': 'https://randomuser.me/api/portraits/women/2.jpg',
      'lastMessage': 'Thanks for the confirmation!',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 0,
      'lastSender': 'provider',
    },
    {
      'id': 'chat3',
      'customerId': 'C003',
      'customerName': 'Wei Lin',
      'customerImage': 'https://randomuser.me/api/portraits/women/3.jpg',
      'lastMessage': 'Do you have availability next weekend?',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 1,
      'lastSender': 'customer',
    },
    {
      'id': 'chat4',
      'customerId': 'C004',
      'customerName': 'Sarah Johnson',
      'customerImage': 'https://randomuser.me/api/portraits/women/4.jpg',
      'lastMessage': 'Please remember Bella is sensitive to loud noises',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unreadCount': 0,
      'lastSender': 'customer',
    },
    {
      'id': 'chat5',
      'customerId': 'C005',
      'customerName': 'Ahmad Razali',
      'customerImage': 'https://randomuser.me/api/portraits/men/5.jpg',
      'lastMessage': 'Your booking for Leo has been confirmed for next Monday',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'unreadCount': 0,
      'lastSender': 'provider',
    },
  ];

  // Filtered conversations based on search
  List<Map<String, dynamic>> get filteredConversations {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }
    return _conversations.where((conversation) {
      return conversation['customerName']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Messages'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : null,
      drawer: isSmallScreen
          ? Drawer(
              child: SidebarMenu(
                currentRoute: AppRoutes.chatListRoute,
                onMenuItemSelected: () {
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar menu for large screens
          if (!isSmallScreen && _isSidebarOpen)
            SidebarMenu(currentRoute: AppRoutes.chatListRoute),

          // Toggle button for sidebar
          if (!isSmallScreen)
            InkWell(
              onTap: () {
                setState(() {
                  _isSidebarOpen = !_isSidebarOpen;
                });
              },
              child: Container(
                width: 24,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    _isSidebarOpen ? Icons.chevron_left : Icons.chevron_right,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),

          // Main content area
          Expanded(
            child: Container(
              color: kBackgroundColor,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with search
                  _buildHeader(),

                  // Search field
                  _buildSearchField(),

                  // Chat list
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildChatList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Stay connected with your customers',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildChatList() {
    if (filteredConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: filteredConversations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final conversation = filteredConversations[index];
        return _buildConversationItem(conversation);
      },
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    final unreadCount = conversation['unreadCount'] as int;
    final isUnread = unreadCount > 0;
    final lastSender = conversation['lastSender'] as String;
    final isFromCustomer = lastSender == 'customer';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.chatRoute,
            arguments: conversation['customerId'],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Customer image
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(conversation['customerImage']),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error loading image
                },
                child: conversation['customerImage'].isEmpty
                    ? Text(
                        conversation['customerName'].substring(0, 1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Message preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          conversation['customerName'],
                          style: TextStyle(
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatTimestamp(conversation['timestamp']),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (isFromCustomer == false) ...[
                          const Text(
                            'You: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            conversation['lastMessage'],
                            style: TextStyle(
                              color: isUnread
                                  ? Colors.black
                                  : Colors.grey.shade700,
                              fontWeight: isUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return DateFormat('MMM d, yyyy').format(timestamp);
    } else if (difference.inDays > 7) {
      return DateFormat('MMM d').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

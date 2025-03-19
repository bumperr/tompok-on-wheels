import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:intl/intl.dart';

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = true;
  bool _isSending = false;
  final ScrollController _scrollController = ScrollController();

  // Sample customer data
  late Map<String, dynamic> _customer;

  // Sample messages
  late List<Message> _messages;

  // Provider ID (would come from auth in a real app)
  final String _providerId = 'P001';

  @override
  void initState() {
    super.initState();

    // Initialize with sample data
    _initializeData();

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
      // Scroll to bottom after loading
      _scrollToBottom();
    });
  }

  void _initializeData() {
    _customer = {
      'id': 'C001',
      'name': 'John Doe',
      'imageUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
      'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
      'isOnline': true,
    };

    _messages = [
      Message(
        id: 'm1',
        senderId: 'C001',
        text: 'Hi, I wanted to ask about my booking tomorrow',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'm2',
        senderId: _providerId,
        text: 'Hello! Yes, your booking is confirmed for 10:00 AM tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'm3',
        senderId: 'C001',
        text: 'Great, thanks! Do I need to bring anything specific for Oyen?',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      Message(
        id: 'm4',
        senderId: _providerId,
        text:
            'Just bring his regular food and any toys he likes to play with. We\'ll provide everything else needed for grooming.',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        isRead: true,
      ),
      Message(
        id: 'm5',
        senderId: 'C001',
        text:
            'Also, he\'s a bit nervous around other cats. Will that be an issue?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      Message(
        id: 'm6',
        senderId: 'C001',
        text: 'He had a bad experience at another groomer last time.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
        isRead: false,
      ),
    ];
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    // Clear input field
    _messageController.clear();

    // Create new message
    final newMessage = Message(
      id: 'm${_messages.length + 1}',
      senderId: _providerId,
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Add message to list
    setState(() {
      _messages.add(newMessage);
      _isSending = false;
    });

    // Scroll to the bottom to show new message
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    // Get customer ID from route arguments if available
    final customerId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'C001';

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25,
        title: _isLoading
            ? const Text('Loading...')
            : Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(_customer['imageUrl']),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _customer['name'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        _customer['isOnline']
                            ? 'Online'
                            : 'Last seen ${_formatLastSeen(_customer['lastSeen'])}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/customers/details',
                arguments: customerId,
              );
            },
            tooltip: 'Customer Info',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Message list
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isFromProvider = message.senderId == _providerId;

                        // Group messages by date
                        final showDateSeparator = index == 0 ||
                            !_isSameDay(_messages[index].timestamp,
                                _messages[index - 1].timestamp);

                        return Column(
                          children: [
                            if (showDateSeparator)
                              _buildDateSeparator(message.timestamp),
                            _buildMessageBubble(message, isFromProvider),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Message input
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {
                          // Attachment functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Attachment functionality not implemented yet')),
                          );
                        },
                        color: kPrimaryColor,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        radius: 24,
                        child: IconButton(
                          icon: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send),
                          onPressed: _isSending ? null : _sendMessage,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isFromProvider) {
    final time = DateFormat('h:mm a').format(message.timestamp);

    return Align(
      alignment: isFromProvider ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isFromProvider ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isFromProvider ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isFromProvider
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                if (isFromProvider) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMMM d, yyyy').format(date);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, h:mm a').format(lastSeen);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

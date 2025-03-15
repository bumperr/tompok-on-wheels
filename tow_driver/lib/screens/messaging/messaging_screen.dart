// lib/screens/messaging/messaging_screen.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/data/sample_data.dart';
import 'package:tow_driver/class/message.dart';
import 'package:intl/intl.dart';

class MessagingScreen extends StatefulWidget {
  final String customerId;
  final String customerName;

  const MessagingScreen({
    Key? key,
    required this.customerId,
    required this.customerName,
  }) : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Load conversation history
    _loadMessages();
  }

  void _loadMessages() {
    // Filter messages between driver and customer
    setState(() {
      _messages.addAll(sampleMessages.where((message) =>
          (message.senderId == widget.customerId && message.receiverId == sampleDriver.id) ||
          (message.senderId == sampleDriver.id && message.receiverId == widget.customerId)));
      
      // Sort messages by timestamp
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
    
    // Schedule scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      id: 'msg${DateTime.now().millisecondsSinceEpoch}',
      senderId: sampleDriver.id,
      receiverId: widget.customerId,
      content: _messageController.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _isTyping = false;
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate customer typing and response after a delay
    if (_messages.length % 3 == 0) {
      _simulateCustomerTyping();
    }
  }

  void _simulateCustomerTyping() {
    // Show typing indicator
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = true;
      });
      _scrollToBottom();

      // Send response after another delay
      Future.delayed(const Duration(seconds: 2), () {
        final customerResponse = Message(
          id: 'msg${DateTime.now().millisecondsSinceEpoch}',
          senderId: widget.customerId,
          receiverId: sampleDriver.id,
          content: "Thanks for the update! Please drive safely.",
          timestamp: DateTime.now(),
          isRead: true,
        );

        setState(() {
          _messages.add(customerResponse);
          _isTyping = false;
        });

        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.customerName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customerName,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Customer",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // In a real app, this would initiate a phone call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.customerName}...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
              _showMoreOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    // Show typing indicator
                    return _buildTypingIndicator();
                  }
                  
                  final message = _messages[index];
                  final isFromMe = message.senderId == sampleDriver.id;

                  // Check if we should show timestamp - first message or gap > 10min
                  bool showTimestamp = index == 0 || 
                    _messages[index].timestamp.difference(_messages[index - 1].timestamp).inMinutes > 10;

                  return Column(
                    children: [
                      if (showTimestamp)
                        _buildTimestampDivider(message.timestamp),
                      _buildMessageBubble(message, isFromMe),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Quick message options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _buildQuickReplyChip("I'm on my way"),
                _buildQuickReplyChip("Be there in 5 minutes"),
                _buildQuickReplyChip("I have arrived"),
                _buildQuickReplyChip("Your pet is safe and doing well"),
                _buildQuickReplyChip("We're almost at the destination"),
              ],
            ),
          ),
          
          // Input area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    color: Colors.grey,
                    onPressed: () {
                      // Show attachment options
                      _showAttachmentOptions();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: kPrimaryColor,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isFromMe) {
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isFromMe ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isFromMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: TextStyle(
                    color: isFromMe ? Colors.white70 : Colors.grey,
                    fontSize: 10,
                  ),
                ),
                if (isFromMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    color: Colors.white70,
                    size: 14,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampDivider(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              DateFormat('MMM d, yyyy • h:mm a').format(timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(200),
            _buildTypingDot(500),
            _buildTypingDot(800),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int milliseconds) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.5, end: 1.0),
        duration: Duration(milliseconds: milliseconds),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplyChip(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(text),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block Customer'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is just a demo. Customer not blocked.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                // Show report dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Chat History'),
              onTap: () {
                Navigator.pop(context);
                // Show confirmation dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: kPrimaryColor),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Launch camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: kPrimaryColor),
              title: const Text('Photo Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Open gallery
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: kPrimaryColor),
              title: const Text('Share Location'),
              onTap: () {
                Navigator.pop(context);
                // Share current location
                _messageController.text = "Here's my current location: [Location]";
                _sendMessage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: kPrimaryColor),
              title: const Text('Pet Transportation Document'),
              onTap: () {
                Navigator.pop(context);
                // Share document
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document shared successfully')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
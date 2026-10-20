import 'package:flutter/material.dart';
import 'package:why/screens/chat_screen.dart';
import 'package:why/services/api_service.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;

  ChatListScreen({required this.userId});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await apiService.fetchChats(widget.userId);

      if (response.containsKey('status') && response['status'] == 'success') {
        if (response.containsKey('chats') && response['chats'] is List) {
          setState(() {
            _chats = List<Map<String, dynamic>>.from(response['chats']);
            _isLoading = false;
          });
        } else {
          print('Chats not found in response: ${response['chats']}');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Error fetching chats: ${response['message']}');
        setState(() {
          _isLoading = false;
        });
      }
      } catch (e) {
      print('Error fetching chats: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chat List'),
        backgroundColor: Colors.pink,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _chats.isEmpty
              ? Center(child: Text('No chats available'))
              : ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    return GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: widget.userId,
                              otherUserId: chat['chat_partner_id'].toString(),
                              otherUserName:
                                  chat['chat_partner_name'] ?? 'Unknown',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chat['chat_partner_name'] ?? 'Unknown',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                chat['last_message'] ?? 'No messages',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

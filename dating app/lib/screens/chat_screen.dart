import 'package:flutter/material.dart';
import 'package:why/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String otherUserId;
  final String otherUserName;

  ChatScreen(
      {required this.userId,
      required this.otherUserId,
      required this.otherUserName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ApiService apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': widget.userId,
          'message': messageText,
        });
      });

      // Send the message to the server
      await apiService.sendMessage(
        widget.userId,
        widget.otherUserId,
        messageText,
      );

      // Clear the text field after sending the message
      _messageController.clear();
    }
  }

  void _fetchMessages() async {
    final fetchedMessages =
        await apiService.getMessages(widget.userId, widget.otherUserId);
    setState(() {
      _messages.clear();
      _messages.addAll(fetchedMessages.map((msg) => {
            'sender': msg['sender_id'].toString(),
            'message': msg['message'],
          }));
      _isLoading = false;
    });
  }

  // Function to open the report dialog
  void _openReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedReason;
        return AlertDialog(
          title: Text("Report User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select a reason for reporting:"),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedReason,
                hint: Text("Choose reason"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedReason = newValue;
                  });
                },
                items: <String>['Spam', 'Harassment', 'Inappropriate Content']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (selectedReason != null) {
                  await apiService.reportUser(
                    widget.userId,
                    widget.otherUserId,
                    selectedReason!,
                  );

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User reported successfully")),
                  );

                  Navigator.of(context).pop();
                } else {
                  // Show an error if no reason was selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please select a reason to report.")),
                  );
                }
              },
              child: Text("Report"),
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
        title: Text("Chat with ${widget.otherUserName}"),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to ChatListScreen
          },
        ),
        actions: [
          // Report Button in the AppBar
          Tooltip(
            message: 'Report',
            child: IconButton(
              icon: Icon(Icons.report_problem),
              onPressed: _openReportDialog,
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe = message['sender'] == widget.userId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 18),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 18),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.pink[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(message['message']!),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Write a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.pink),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

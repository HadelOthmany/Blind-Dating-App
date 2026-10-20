import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminPage extends StatefulWidget {
  final String adminId;

  AdminPage({required this.adminId});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> reportedUsers = [];
  List<Map<String, dynamic>> blockedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadReportedUsers();
    _loadBlockedUsers();
  }

  Future<void> _loadReportedUsers() async {
    try {
      var response = await apiService.fetchReportedUsers();
      if (response['status'] == 'success') {
        setState(() {
          // Ensure the data is an empty list if no users are found
          reportedUsers =
              List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reported users')),
        );
      }
    } catch (e) {
      print('Error loading reported users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading reported users')),
      );
    }
  }

  Future<void> _loadBlockedUsers() async {
    try {
      var response = await apiService.fetchBlockedUsers();
      if (response['status'] == 'success') {
        setState(() {
          blockedUsers = List<Map<String, dynamic>>.from(response['data']);
        });
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load blocked users')),
        );
      }
    } catch (e) {
      print('Error loading blocked users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading blocked users')),
      );
    }
  }

  Future<void> _blockUser(String userId, String reportedUserEmail,
      String reportReason, String reportId) async {
    var response = await apiService.blockUser(
        userId, reportedUserEmail, reportReason, reportId);
    if (response['status'] == 'success') {
      _loadReportedUsers(); // Refresh the reported users list
      _loadBlockedUsers(); // Refresh the blocked users list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User blocked successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error blocking user: ${response['message']}')),
      );
    }
  }

  Future<void> _unblockUser(String userId) async {
    var response = await apiService.unblockUser(userId);
    if (response['status'] == 'success') {
      _loadReportedUsers();
      _loadBlockedUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User unblocked successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error unblocking user: ${response['message']}')),
      );
    }
  }

  Future<void> _ignoreReport(String reportId) async {
    try {
      var response = await apiService.ignoreReport(reportId);
      if (response['status'] == 'success') {
        _loadReportedUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report ignored')),
        );
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      print('Error ignoring report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ignoring report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: ListView(
        children: [
          // Reported Users List
          reportedUsers.isEmpty
              ? Center(child: Text('No reported users'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reported Users',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reportedUsers.length,
                        itemBuilder: (context, index) {
                          final user = reportedUsers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reported User: ${user['reported_user']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      'Reporting User: ${user['reporting_user']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Report Reason: ${user['report_reason']}',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Tooltip(
                                    message: 'Block',
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.block, color: Colors.red),
                                      onPressed: () => _blockUser(
                                          user['reported_user_id'],
                                          user['reported_user_email'],
                                          user['report_reason'],
                                          user['report_id']),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'Ignore',
                                    child: IconButton(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () =>
                                          _ignoreReport(user['report_id']),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

          // Blocked Users List
          blockedUsers.isEmpty
              ? SizedBox()
                            : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blocked Users',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: blockedUsers.length,
                        itemBuilder: (context, index) {
                          final user = blockedUsers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                'Blocked User: ${user['reported_user']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Blocked Reason: ${user['report_reason']}',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              trailing: Tooltip(
                                message: 'Unblock',
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.blue),
                                  onPressed: () => _unblockUser(user['id']),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.132.174.45/datingpro";

  Future<Map<String, dynamic>> registerUser(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      print('Register Response Status: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {
        'status': 'error',
        'message': 'Failed to connect to the server: $e'
      };
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to connect to the server: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_user_profile.php"),
        body: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == 'success') {
          return decoded;
        } else {
          return {
            'status': 'error',
            'message': decoded['message'] ?? 'Error fetching data'
          };
        }
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to connect to the server: $e'
      };
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_user_profile.php"),
        body: {...profileData},
      );
      print('Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<void> markAsFavorite(String userId, String favoriteUserId) async {
    print("$userId");
    print("$favoriteUserId");
    final response = await http.post(
      Uri.parse('$baseUrl/marke_as_favorite.php'),
      body: {
        'user_id': userId,
        'favorite_user_id': favoriteUserId,
      },
    );
    if (response.statusCode == 200) {
      print("Server response: ${response.body}");
      print("Profile marked as favorite.");
    } else {
      print("Failed to mark as favorite.");
      print("Response: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchFavoriteSent(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_favorite_sent.php"),
        body: {'user_id': userId},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<Map<String, dynamic>> fetchFavoriteReceived(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_favorite_received.php"),
        body: {'user_id': userId},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<void> markAsLike(String userId, String likeUserId) async {
    print("$userId");
    print("$likeUserId");
    final response = await http.post(
      Uri.parse('$baseUrl/marke_as_like.php'),
      body: {
        'user_id': userId,
        'like_user_id': likeUserId,
      },
    );
    if (response.statusCode == 200) {
      print("Server response: ${response.body}");
      print("Profile marked as liked.");
    } else {
      print("Failed to mark as liked.");
      print("Response: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchLikesSent(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_likes_sent.php"),
        body: {'user_id': userId},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<Map<String, dynamic>> fetchLikesReceived(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_likes_received.php"),
        body: {'user_id': userId},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<void> reportUser(
      String userId, String otherUserId, String selectedReason) async {
    final url = Uri.parse('$baseUrl/report_user.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'reportingUser': userId,
          'reportedUser': otherUserId,
          'message': selectedReason,
        }),
      );

      if (response.statusCode == 200) {
        print('Report sent!');
      } else {
        print('Something went wrong while reporting: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendMessage(
      String currentUserId, String otherUserId, String message) async {
    final url = Uri.parse('$baseUrl/send_message.php');

    try {
      final response = await http.post(
        url,
        body: {
          'currentUserId': currentUserId,
          'otherUserId': otherUserId,
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        print('Meddelande skickat!');
      } else {
        print('Fel vid skickande av meddelande: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(
      String userId, String otherUserId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_messages.php"),
        body: {
          'user_id': userId,
          'other_user_id': otherUserId,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        print("Server error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchChats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/get_chatlist.php?currentUserId=$userId"),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('Decoded response: $decoded');
        if (decoded.containsKey('chats')) {
          return {
            'status': 'success',
            'chats': decoded['chats'],
          };
        } else {
          return {
            'status': 'error',
            'message': 'Chats not found in response.',
          };
        }
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to connect: $e',
      };
    }
  }

  Future<Map<String, dynamic>> ignoreReport(String reportId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/ignore_report.php"),
        body: {'report_id': reportId},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to ignore the report.'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
     }

  Future<Map<String, dynamic>> blockUser(String userId,
      String reportedUserEmail, String reportReason, String reportId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/block_user.php"),
        body: {
          'user_id': userId,
          'email': reportedUserEmail,
          'report_reason': reportReason,
          'report_id': reportId
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<Map<String, dynamic>> fetchReportedUsers() async {
    final url = Uri.parse('$baseUrl/fetch_reported_users.php');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load reported users');
      }
    } catch (e) {
      print('Error fetching reported users: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchBlockedUsers() async {
    final url = Uri.parse('$baseUrl/fetch_blocked_users.php');

    try {
      final response = await http.get(url);

if (response.statusCode == 200) {
        return {'status': 'success', 'data': json.decode(response.body)};
      } else {
        return {'status': 'error', 'message': 'Failed to load reported users'};
      }
    } catch (e) {
      print('Error fetching reported users: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> unblockUser(String blockId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/unblock_user.php"),
        body: {'id': blockId},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect: $e'};
    }
  }

  Future<Map<String, bool>> fetchUserStatus(
      String userId, String profileId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fetch_user_status.php'),
      body: {'user_id': userId, 'profile_id': profileId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'is_favorited': data['is_favorited'],
        'is_liked': data['is_liked'],
      };
    } else {
      throw Exception('Failed to load user status');
    }
  }

}

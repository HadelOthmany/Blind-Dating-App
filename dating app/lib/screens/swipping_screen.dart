import 'package:flutter/material.dart';

import '../users/model/users_profiles.dart';
import '../services/api_service.dart';
import '../screens/chat_screen.dart';
import '../screens/user_profile_page.dart';
import '../widgets/filter_dialog.dart';

class SwippingScreen extends StatefulWidget {
  final String userId;

  SwippingScreen({required this.userId});
  @override
  State<SwippingScreen> createState() => _SwippingScreenState();
}

class _SwippingScreenState extends State<SwippingScreen> {
  late Future<List<Person>> _usersFuture;
  final ApiService apiService = ApiService();
  Map<String, dynamic>? _activeFilters;

  Map<int, bool> isFavorited = {};
  Map<int, bool> isLiked = {};
  List<Map<String, dynamic>> profiles = [];

  @override
  void initState() {
    super.initState();
    isFavorited = {};
    isLiked = {};
    _loadUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserStatus();
  }

  Future<void> fetchUserStatus(String userId, int profileId) async {
    try {
      // Hämta status från API:et
      Map<String, bool> status =
          await apiService.fetchUserStatus(userId, profileId.toString());
      print("Fetched status for profile $profileId: $status");

      setState(() {
        isFavorited[profileId] = status['is_favorited'] ?? false;
        isLiked[profileId] = status['is_liked'] ?? false;
      });
    } catch (e) {
      print('Failed to load user status: $e');
    }
  }

  Future<void> _loadUserStatus() async {
    for (var eachProfileInfo in profiles) {
      final profileId = eachProfileInfo['id'];
      if (profileId != null) {
        try {
          Map<String, bool> status = await apiService.fetchUserStatus(
            widget.userId,
            profileId.toString(),
          );
          setState(() {
            isFavorited[profileId] = status['is_favorited'] ?? false;
            isLiked[profileId] = status['is_liked'] ?? false;
          });
        } catch (e) {
          print('Failed to fetch status for profile $profileId: $e');
        }
      }
    }
  }

  void _loadUsers() {
    if (_activeFilters != null) {
      _usersFuture = Person.getFilteredUsers(widget.userId, _activeFilters!);
      } else {
      _usersFuture = Person.getAllUsersExceptLoggedIn(widget.userId);
    }
    _usersFuture.then((users) {
      profiles = users
          .map((user) => {
                'id': user.id,
                'name': user.name,
              })
          .toList();

      _loadUserStatus();
    }).catchError((error) {
      print("Error loading users: $error");
    });
  }

  void applyFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onApplyFilters: (Map<String, dynamic> filters) {
            setState(() {
              _activeFilters = filters;
              _loadUsers();
            });
          },
        );
      },
    );
  }

  void clearFilters() {
    setState(() {
      _activeFilters = null;
      _loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: FutureBuilder<List<Person>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No users available'),
                  if (_activeFilters != null)
                    ElevatedButton(
                      onPressed: clearFilters,
                      child: Text('Clear Filters'),
                    ),
                ],
              ),
            );
          } else {
            List<Person> users = snapshot.data!;

            return isLandscape
                ? ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final eachProfileInfo = users[index];
                      return _buildProfileCard(eachProfileInfo);
                    },
                  )
                  : PageView.builder(
                    itemCount: users.length,
                    controller:
                        PageController(initialPage: 0, viewportFraction: 1),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final eachProfileInfo = users[index];
                      return _buildProfileCard(eachProfileInfo);
                    },
                  );
          }
        },
      ),
    );
  }

  Widget _buildProfileCard(Person eachProfileInfo) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/avatar.jpeg"), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: applyFilter,
                  icon: Icon(
                    Icons.filter_list,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                if (_activeFilters != null && _activeFilters!.isNotEmpty)
                  IconButton(
                    onPressed: clearFilters,
                    icon: Icon(
                      Icons.clear,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                        userProfile: eachProfileInfo, userId: widget.userId),
                  ),
                );
              },
              child: Column(
                children: [
                  Text(
                    eachProfileInfo.name!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${eachProfileInfo.birthdate} ◉ ${eachProfileInfo.city}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 4,
                    ),
                  ),
                   SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          eachProfileInfo.profession!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          eachProfileInfo.religion!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          eachProfileInfo.country!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          eachProfileInfo.ethnicity!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    apiService
                        .markAsFavorite(
                            widget.userId, eachProfileInfo.id.toString())
                        .then((_) {
                      apiService
                          .fetchUserStatus(
                              widget.userId, eachProfileInfo.id.toString())
                          .then((status) {
                        setState(() {
                          // Uppd UI
                          isFavorited[eachProfileInfo.id!] =
                              status['is_favorited']!;
                        });
                      });
                    });
                  },
                  child: Image.asset(
                    isFavorited[eachProfileInfo.id] ?? false
                        ? 'assets/favorite.png'
                        : 'assets/unfavorite.png',
                    width: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userId: widget.userId,
                          otherUserId: eachProfileInfo.id.toString(),
                          otherUserName: eachProfileInfo.name!,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/masg.png",
                    width: 90,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    apiService
                        .markAsLike(
                            widget.userId, eachProfileInfo.id.toString())
                        .then((_) {
                      apiService
                          .fetchUserStatus(
                              widget.userId, eachProfileInfo.id.toString())
                          .then((status) {
                        setState(() {
                          // Uppd UI
                          isLiked[eachProfileInfo.id!] = status['is_liked']!;
                        });
                      });
                    });
                  },
                  child: Image.asset(
                    isLiked[eachProfileInfo.id] ?? false
                        ? 'assets/love.png'
                        : 'assets/unlove.png',
                    width: 60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

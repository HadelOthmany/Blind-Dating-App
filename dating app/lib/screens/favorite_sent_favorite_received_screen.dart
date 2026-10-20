import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/user_profile_page.dart';
import '../users/model/users_profiles.dart';

class FavoriteSentFavoriteReceivedScreen extends StatefulWidget {
  final String userId;

  FavoriteSentFavoriteReceivedScreen({required this.userId});

  @override
  State<FavoriteSentFavoriteReceivedScreen> createState() =>
      _FavoriteSentFavoriteReceivedScreenState();
}

class _FavoriteSentFavoriteReceivedScreenState
    extends State<FavoriteSentFavoriteReceivedScreen> {
  bool isFavoriteSentClicked = true;
  List<dynamic> favoritesList = [];
  final ApiService apiService = ApiService();

  Future<void> getFavorites() async {
    setState(() {
      favoritesList.clear();
    });

    try {
      final response = isFavoriteSentClicked
          ? await apiService.fetchFavoriteSent(widget.userId)
          : await apiService.fetchFavoriteReceived(widget.userId);

      if (response['status'] == 'success') {
        setState(() {
          favoritesList = response['data'];
        });
      } else {
        print('Error: ${response['message']}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isFavoriteSentClicked = true;
                });
                getFavorites();
              },
              child: Text(
                "My Favorites",
                style: TextStyle(
                  color: isFavoriteSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isFavoriteSentClicked
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            const Text(
              "   -   ",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isFavoriteSentClicked = false;
                });
                getFavorites();
              },
              child: Text(
                "I'm Their Favorite",
                style: TextStyle(
                  color: isFavoriteSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isFavoriteSentClicked
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: favoritesList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.black,
                size: 60,
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: favoritesList.length,
              itemBuilder: (context, index) {
                final favorite = favoritesList[index];

                final person = Person(
                  id: favorite['id'],
                  name: favorite['name'],
                  gender: favorite['gender'],
                  email: favorite['email'],
                  phone_no: favorite['phone_no'],
                  city: favorite['city'],
                  country: favorite['country'],
                  profile_heading: favorite['profile_heading'],
                  looking_for_partner: favorite['looking_for_partner'],
                  height: favorite['height'],
                  weight: favorite['weight'],
                  body_type: favorite['body_type'],
                  profession: favorite['profession'],
                  living_situation: favorite['living_situation'],
                  willing_to_relocate: favorite['willing_to_relocate'],
                  relationship_looking_for:
                      favorite['relationship_looking_for'],
                  nationality: favorite['nationality'],
                  education: favorite['education'],
                  languages_spoken: favorite['languages_spoken'],
                  religion: favorite['religion'],
                  ethnicity: favorite['ethnicity'],
                  birthdate: favorite['birthdate'],
                  drinks: favorite['drinks'],
                  smokes: favorite['smokes'],
                  have_children: favorite['have_children'],
                  no_of_children: favorite['no_of_children'],
                  employment_status: favorite['employment_status'],
                  income: favorite['income'],
                );

                return Card(
                  color: Colors.blue.shade200,
                  child: GestureDetector(
                    onTap: () {},
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/avatar.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Text(
                                  "${favorite['name']} ⦿ ${favorite['birthdate']}",
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  "${favorite['city']}, ${favorite['country']}",
                                  maxLines: 2,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to user profile page and pass the Person object
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfilePage(
                                        userProfile: person,
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: Text("View Profile"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

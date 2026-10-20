import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/user_profile_page.dart';
import '../users/model/users_profiles.dart';


class LikeSentLikeReceivedScreen extends StatefulWidget {
  final String userId;

  LikeSentLikeReceivedScreen({required this.userId});

  @override
  State<LikeSentLikeReceivedScreen> createState() =>
      _LikeSentLikeReceivedScreenState();
}

class _LikeSentLikeReceivedScreenState
    extends State<LikeSentLikeReceivedScreen> {
  bool isLikeSentClicked = true;
  List<dynamic> likesList = [];
  final ApiService apiService = ApiService();

  Future<void> getLikes() async {
    setState(() {
      likesList.clear();
    });

    try {
      final response = isLikeSentClicked
          ? await apiService.fetchLikesSent(widget.userId)
          : await apiService.fetchLikesReceived(widget.userId);

      if (response['status'] == 'success') {
        setState(() {
          likesList = response['data'];
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
    getLikes();
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
                  isLikeSentClicked = true;
                });
                getLikes();
              },
              child: Text(
                "My Likes",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.white : Colors.grey,
                  fontWeight:
                      isLikeSentClicked ? FontWeight.bold : FontWeight.normal,
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
                  isLikeSentClicked = false;
                });
                getLikes();
              },
              child: Text(
                "Liked Me",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.grey : Colors.white,
                  fontWeight:
                      isLikeSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: likesList.isEmpty
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
              itemCount: likesList.length,
              itemBuilder: (context, index) {
                final favorite = likesList[index];
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

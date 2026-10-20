import 'package:flutter/material.dart';
import 'package:why/screens/chat_screen.dart';
import '../users/model/users_profiles.dart';
import '../widgets/custom_info_table.dart';

class UserProfilePage extends StatelessWidget {
  final Person userProfile;
  final String userId;

  UserProfilePage({
    required this.userProfile,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 244, 137, 173),
      ),
      backgroundColor: const Color.fromARGB(255, 244, 137, 173),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Column(
                children: [
                  CustomInfoTable(
                    title: "Personal Info:",
                     data: [
                      {'label': 'Gender:', 'value': '${userProfile.gender}'},
                      {'label': 'Name:', 'value': '${userProfile.name}'},
                      {
                        'label': 'Birth Date:',
                        'value': '${userProfile.birthdate}'
                      },
                      {'label': 'City:', 'value': '${userProfile.city}'},
                      {'label': 'Country:', 'value': '${userProfile.country}'},
                      {
                        'label': 'Profile Heading:',
                        'value': '${userProfile.profile_heading}'
                      },
                      {
                        'label': 'Looking For in A Partner:',
                        'value': '${userProfile.looking_for_partner}'
                      },
                    ],
                  ),
                  CustomInfoTable(
                    title: "Appearance:",
                    data: [
                      {'label': 'Height:', 'value': '${userProfile.height}'},
                      {'label': 'Weight:', 'value': '${userProfile.weight}'},
                      {
                        'label': 'Body Type:',
                        'value': '${userProfile.body_type}'
                      },
                    ],
                  ),
                  CustomInfoTable(
                    title: "Life Style:",
                     data: [
                      {
                        'label': 'Profession:',
                        'value': '${userProfile.profession}'
                      },
                      {
                        'label': 'Living Situation:',
                        'value': '${userProfile.living_situation}'
                      },
                      {
                        'label': 'Relationship Looking For:',
                        'value': '${userProfile.relationship_looking_for}'
                      },
                      {
                        'label': 'Willing To Relocate:',
                        'value':
                            userProfile.willing_to_relocate == 0 ? 'No' : 'Yes'
                      },
                      {
                        'label': 'Drinks:',
                        'value': userProfile.drinks == 0 ? 'No' : 'Yes'
                      },
                      {
                        'label': 'Smokes:',
                        'value': userProfile.smokes == 0 ? 'No' : 'Yes'
                      },
                      {
                        'label': 'Have Children:',
                        'value': userProfile.have_children == 0 ? 'No' : 'Yes'
                      },
                      {
                        'label': 'Number Of Children:',
                        'value': '${userProfile.no_of_children}'
                      },
                    ],
                  ),
                  CustomInfoTable(
                    title: "Background:",
                    data: [
                      {
                        'label': 'Nationality:',
                        'value': '${userProfile.nationality}'
                      },
                      {
                        'label': 'Education:',
                        'value': '${userProfile.education}'
                      },
                      {
                        'label': 'Language Spoken:',
                        'value': '${userProfile.languages_spoken}'
                      },
                      {
                        'label': 'Religion:',
                        'value': '${userProfile.religion}'
                      },
                      {
                        'label': 'Ethnicity:',
                        'value': '${userProfile.ethnicity}'
                      },
                      {
                        'label': 'Employment Status:',
                        'value': '${userProfile.employment_status}'
                      },
                      {'label': 'Income:', 'value': '${userProfile.income}'},
                         ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (userProfile.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: userId,
                              otherUserId: userProfile.id.toString(),
                              otherUserName: userProfile.name ?? 'Unknown',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('User profile ID is missing!')),
                        );
                      }
                    },
                    child: Text("Chat here"),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

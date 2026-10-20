import 'package:flutter/material.dart';
import '../widgets/custom_info_table.dart';
import '../screens/profile_page.dart';
import '../users/model/users_profiles.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  UserDetailsScreen({required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool isLoading = false;
  late Future<Person?> _personInfo;

  @override
  void initState() {
    super.initState();
    _personInfo = Person.fromDatabase(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              FutureBuilder<Person?>(
                future: _personInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data found'));
                  } else {
                    print('Fetched Person: ${snapshot.data}');
                    final person = snapshot.data!;
                    return Column(
                      children: [
                        CustomInfoTable(
                          title: "Personal Info:",
                          data: [
                            {'label': 'Gender:', 'value': '${person.gender}'},
                            {'label': 'Name:', 'value': '${person.name}'},
                            {'label': 'Email:', 'value': '${person.email}'},
                            {
                              'label': 'Birth Date:',
                              'value': '${person.birthdate}'
                            },
                            {
                              'label': 'Phone Number:',
                              'value': '${person.phone_no}'
                            },
                            {'label': 'City:', 'value': '${person.city}'},
                            {'label': 'Country:', 'value': '${person.country}'},
                            {
                              'label': 'Profile Heading:',
                              'value': '${person.profile_heading}'
                            },
                            {
                              'label': 'Looking For in A Partner:',
                              'value': '${person.looking_for_partner}'
                            },
                          ],
                        ),
                        CustomInfoTable(
                          title: "Appearance:",
                          data: [
                            {'label': 'Height:', 'value': '${person.height}'},
                            {'label': 'Weight:', 'value': '${person.weight}'},
                            {
                              'label': 'Body Type:',
                              'value': '${person.body_type}'
                            },
                          ],
                        ),
                        CustomInfoTable(
                          title: "Life Style:",
                          data: [
                            {
                              'label': 'Profession:',
                              'value': '${person.profession}'
                            },
                            {
                              'label': 'Living Situation:',
                              'value': '${person.living_situation}'
                            },
                            {
                              'label': 'Relationship Looking For:',
                              'value': '${person.relationship_looking_for}'
                            },
                            {
                              'label': 'Willing To Relocate:',
                              'value':
                                  person.willing_to_relocate == 0 ? 'No' : 'Yes'
                            },
                            {
                              'label': 'Drinks:',
                              'value': person.drinks == 0 ? 'No' : 'Yes'
                            },
                            {
                              'label': 'Smokes:',
                              'value': person.smokes == 0 ? 'No' : 'Yes'
                            },
                            {
                              'label': 'Have Children:',
                              'value': person.have_children == 0 ? 'No' : 'Yes'
                            },
                            {
                              'label': 'Number Of Children:',
                              'value': '${person.no_of_children}'
                            },
                          ],
                        ),
                        CustomInfoTable(
                          title: "Background:",
                          data: [
                            {
                              'label': 'Nationality:',
                              'value': '${person.nationality}'
                            },
                            {
                              'label': 'Education:',
                              'value': '${person.education}'
                            },
                            {
                              'label': 'Language Spoken:',
                              'value': '${person.languages_spoken}'
                            },
                            {
                              'label': 'Religion:',
                              'value': '${person.religion}'
                            },
                            {
                              'label': 'Ethnicity:',
                              'value': '${person.ethnicity}'
                            },
                            {
                              'label': 'Employment Status:',
                              'value': '${person.employment_status}'
                            },
                            {'label': 'Income:', 'value': '${person.income}'},
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePage(userId: widget.userId),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text('Edit My Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 246, 109, 194),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

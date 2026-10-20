import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';
import '../screens/admin_page.dart'; // Make sure to import your AdminPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Perform login request
        final response = await apiService.loginUser(
          _usernameController.text,
          _passwordController.text,
        );

        setState(() {
          isLoading = false;
        });

        if (response['status'] == 'success') {
          final String userId = response['userId'];
          final String email = _usernameController.text;

          // Check if the email is the admin's email
          if (email == 'hadel.othmany@gmail.com') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPage(adminId: userId),
              ),
            );
          } else {
            final userProfile = await apiService.getUserProfile(userId);

            bool isProfileComplete = _isProfileComplete(userProfile);
            print('User profile: $userProfile');

            if (isProfileComplete) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userId: userId),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: userId),
                ),
              );
            }
          }
        } else if (response['message'] == 'Your account is blocked') {
          // Handle blocked user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your account is blocked')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  bool _isProfileComplete(Map<String, dynamic> userProfile) {
    final requiredFields = [
      'name',
      'email',
      'phone_no',
      'city',
      'country',
      'profile_heading',
      'looking_for_partner',
      'height',
      'weight',
      'body_type',
      'profession',
      'living_situation',
      'willing_to_relocate',
      'relationship_looking_for',
      'nationality',
      'education',
      'languages_spoken',
      'religion',
      'ethnicity',
      'birthdate',
      'drinks',
      'smokes',
      'have_children',
      'no_of_children',
      'employment_status',
      'income',
    ];

    final profileData = userProfile['data'];

    for (var field in requiredFields) {
      if (profileData[field] == null || profileData[field].toString().isEmpty) {
        print('Incomplete field: $field');
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img4.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 246, 109, 194),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () => Navigator.pop(
                        context), // Navigates back to the previous page
                    child: Text('Back', style: TextStyle(fontSize: 16)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration:
                                    InputDecoration(labelText: ' Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 246, 109, 194),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                onPressed: isLoading ? null : _loginUser,
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text('Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

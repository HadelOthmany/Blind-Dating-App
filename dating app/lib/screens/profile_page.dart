import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../services/api_service.dart';
import '../screens/home_page.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/custom_boolean_field_widget.dart';
import '../screens/login_page.dart';
import '../widgets/custom_select_field_widget.dart';
import '../widgets/country_drop_down_widget.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  bool isLoading = false;

  // Personal Info
  String? selectGenderOption;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? _selectedCountry;
  final TextEditingController _profileHeadingController =
      TextEditingController();
  final TextEditingController _lookingForInaPartnerController =
      TextEditingController();

  // Appearance
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? selectBodyTypeOption;

  // Lifestyle
  final TextEditingController _professionController = TextEditingController();
  String? selectedLivingSituationOption;
  bool? _willingToRelocate;
  String? selectedrelationshipLookingForOption;

  // Background
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _languageSpokenController =
      TextEditingController();
  String? selectedEducationOption;
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  DateTime? _selectedBirthDate;

  bool? _drinks;
  bool? _smokes;
  bool? _haveChildren;

  final TextEditingController _noOfChildrenController = TextEditingController();

  String? selectedEmploymentStatusOption;
  final TextEditingController _incomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userProfile = await apiService.getUserProfile(widget.userId);
      if (userProfile['status'] == 'success') {
        final data = userProfile['data'];

        // Assign values to controllers
        String genderFromDb = (data['gender'] ?? '').toString();
        setGenderOption(genderFromDb);
        _nameController.text = (data['name'] ?? '').toString();
        _emailController.text = (data['email'] ?? '').toString();
        _phoneNoController.text = (data['phone_no'] ?? '').toString();
        _cityController.text = (data['city'] ?? '').toString();
        _countryController.text = (data['country'] ?? '').toString();
        _selectedCountry = (data['country'] ?? '').toString();
        _profileHeadingController.text =
            (data['profile_heading'] ?? '').toString();
        _lookingForInaPartnerController.text =
            (data['looking_for_partner'] ?? '').toString();
        _heightController.text = (data['height'] ?? '').toString();
        _weightController.text = (data['weight'] ?? '').toString();

        _professionController.text = (data['profession'] ?? '').toString();
        String livingSituationFromDb =
            (data['living_situation'] ?? '').toString();
        setLivingSituationOption(livingSituationFromDb);
        _willingToRelocate = (data['willing_to_relocate'] ?? 0) == 1;
        String relationshipLookingForFromDb =
            (data['relationship_looking_for'] ?? '');
        setrelationshipLookingForOption(relationshipLookingForFromDb);
        _nationalityController.text = (data['nationality'] ?? '').toString();
        _languageSpokenController.text =
            (data['languages_spoken'] ?? '').toString();
        _religionController.text = (data['religion'] ?? '').toString();
        _ethnicityController.text = (data['ethnicity'] ?? '').toString();

        // Handle date and boolean values
        _selectedBirthDate = data['birthdate'] != null
            ? DateTime.parse(data['birthdate'])
            : null;
        _drinks = (data['drinks'] ?? 0) == 1;
        _smokes = (data['smokes'] ?? 0) == 1;
        _haveChildren = (data['have_children'] ?? 0) == 1;
        _noOfChildrenController.text =
            (data['no_of_children'] ?? '').toString();
                String employmentStatusFromDb =
            (data['employment_status'] ?? '').toString();
        setEmploymentStatusOption(employmentStatusFromDb);
        _incomeController.text = (data['income'] ?? '').toString();

        // Handle the education field
        String educationFromDb = (data['education'] ?? '').toString();
        setEducationOption(educationFromDb);
        String bodyTypeFromDb = (data['body_type'] ?? '').toString();
        setbodyTypeOption(bodyTypeFromDb);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userProfile['message'])),
        );
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setEducationOption(String educationFromDb) {
    List<String> educationLevels = [
      'Preschool',
      'Primary,
      'Lower Secondary',
      'Upper Secondary',
      'Vocational Education and Training',
      'Associate’s Degree',
      'Bachelor’s Degree',
      'Master’s Degree',
      'Doctoral Degree (Ph.D.)',
      'Postdoctoral Research',
      'Adult Education',
    ];

    if (educationLevels.contains(educationFromDb)) {
      setState(() {
        selectedEducationOption = educationFromDb;
      });
    }
  }

  void setGenderOption(String genderFromDb) {
    List<String> genderOption = [
      "Male",
      "Female",
      "Other",
    ];

    if (genderOption.contains(genderFromDb)) {
      setState(() {
        selectGenderOption = genderFromDb;
      });
    }
  }

  void setbodyTypeOption(String bodyTypeFromDb) {
    List<String> bodyTyps = [
      "Slim / Lean",
      "Athletic / Toned",
      "Curvy",
      "Average",
      "Plus-Size",
      "Muscular / Bodybuilder",
      "Stocky / Solid",
      "Petite",
      "Full-Figured",
      "Round / Soft",
      "Hourglass",
      "Apple-Shaped",
      "Pear-Shaped",
      "Inverted Triangle",
      "I'd rather not say",
    ];

    if (bodyTyps.contains(bodyTypeFromDb)) {
      setState(() {
        selectBodyTypeOption = bodyTypeFromDb;
      });
    }
  }

  void setLivingSituationOption(String livingSituationFromDb) {
    List<String> livingSituation = [
      "Own a house",
      "Own an apartment",
      "Rent a house",
      "Rent an apartment",
      "Rent with roommate",
      "With my parents",
      "Other",
    ];
    if (livingSituation.contains(livingSituationFromDb)) {
      setState(() {
        selectedLivingSituationOption = livingSituationFromDb;
      });
    }
  }

  void setrelationshipLookingForOption(String relationshipLookingForFromDb) {
    List<String> relationshipLookingFor = [
      "Marriage",
      "Engagement",
      "Friendship",
      "Love",
      "Other",
    ];
    if (relationshipLookingFor.contains(relationshipLookingForFromDb)) {
      setState(() {
        selectedrelationshipLookingForOption = relationshipLookingForFromDb;
      });
    }
  }

  void setEmploymentStatusOption(String employmentStatusFromDb) {
    List<String> employmentStatus = [
      "Own a business",
      "Full time employee",
      "Part time employee",
      "Student",
      "Unemployed",
      "Other",
    ];
    if (employmentStatus.contains(employmentStatusFromDb)) {
      setState(() {
        selectedEmploymentStatusOption = employmentStatusFromDb;
      });
    }
  }

  Future<void> _pickBirthDate() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 18),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
      });
    }
  }

  void _submitProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final profileData = {
        'user_id': widget.userId,
        'gender': selectGenderOption ?? '',
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone_no': _phoneNoController.text.trim(),
        'city': _cityController.text.trim(),
        'country': _selectedCountry,
        'profile_heading': _profileHeadingController.text.trim(),
        'looking_for_partner': _lookingForInaPartnerController.text.trim(),
        'height': _heightController.text.trim(),
        'weight': _weightController.text.trim(),
        'body_type': selectBodyTypeOption ?? '',
        'profession': _professionController.text.trim(),
        'living_situation': selectedLivingSituationOption ?? '',
        'willing_to_relocate': (_willingToRelocate ?? false) ? '1' : '0',
        'relationship_looking_for': selectedrelationshipLookingForOption ?? '',
        'nationality': _nationalityController.text.trim(),
        'education': selectedEducationOption ?? '',
        'languages_spoken': _languageSpokenController.text.trim(),
        'religion': _religionController.text.trim(),
        'ethnicity': _ethnicityController.text.trim(),
        'birthdate': _selectedBirthDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedBirthDate!)
            : '',
        'drinks': (_drinks ?? false) ? '1' : '0',
        'smokes': (_smokes ?? false) ? '1' : '0',
        'have_children': (_haveChildren ?? false) ? '1' : '0',
        'no_of_children': _noOfChildrenController.text.trim(),
        'employment_status': selectedEmploymentStatusOption ?? '',
        'income': _incomeController.text.trim(),
      };

      print('$profileData');
      print('$widget.userId');

      setState(() {
        isLoading = true;
      });

      try {
        final response = await apiService.updateUserProfile(profileData);
        print('API Response: $response');

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(userId: widget.userId)),
          );
        } else {
          print('API Error: ${response['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        print('Error Submitting Profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Complete Your Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Info
              SizedBox(height: 20),
              Text("Personal Information",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 10),
              CustomSelectFieldWidget<String>(
                  selectedValue: selectGenderOption,
                  options: [
                    "Male",
                    "Female",
                    "Other",
                  ],
                  labelText: "Gender",
                  iconData: Icons.perm_identity,
                  onChanged: (value) {
                    setState(() {
                      selectGenderOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(
                height: 10,
              ),
              CustomTextFieldWidget(
                  editingController: _nameController,
                  labelText: "Name",
                  iconData: Icons.account_circle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _emailController,
                  labelText: "Email",
                  iconData: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickBirthDate,
                child: AbsorbPointer(
                  child: CustomTextFieldWidget(
                      editingController: TextEditingController(
                        text: _selectedBirthDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(_selectedBirthDate!)
                            : '',
                      ),
                      labelText: "Birthdate (18+ Only)",
                      iconData: Icons.cake_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      }),
                ),
              ),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _phoneNoController,
                  labelText: "Phone Number",
                  iconData: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _cityController,
                  labelText: "City",
                  iconData: Icons.location_city_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
                     SizedBox(height: 10),
              CountryDropdown(
                  initialCountry: _selectedCountry,
                  onCountrySelected: (country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _profileHeadingController,
                  labelText: "Profile Heading",
                  iconData: Icons.title_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _lookingForInaPartnerController,
                  labelText: "Looking For in a Partner",
                  iconData: Icons.search_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),

              // Appearance
              SizedBox(height: 20),
              Text("Appearance",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _heightController,
                  labelText: "Height in cm",
                  iconData: Icons.height,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true), // Allow decimal input
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    // Allow only digits and the decimal point with up to 2 decimal places
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                editingController: _weightController,
                labelText: "Weight in kg",
                iconData: Icons.line_weight,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              CustomSelectFieldWidget<String>(
                  selectedValue: selectBodyTypeOption,
                  options: [
                    "Slim / Lean",
                    "Athletic / Toned",
                    "Curvy",
                    "Average",
                    "Plus-Size",
                    "Muscular / Bodybuilder",
                    "Stocky / Solid",
                    "Petite",
                    "Full-Figured",
                    "Round / Soft",
                    "Hourglass",
                    "Apple-Shaped",
                    "Pear-Shaped",
                    "Inverted Triangle",
                    "I'd rather not say",
                  ],
                  labelText: "Body Type",
                  iconData: Icons.accessibility_new,
                  onChanged: (value) {
                    setState(() {
                      selectBodyTypeOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),

              // Lifestyle
              SizedBox(height: 20),
              Text("Lifestyle",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 10),
              CustomBooleanWidget(
                value: _drinks ?? false,
                onChanged: (value) => setState(() => _drinks = value),
                labelText: "Do you drink?",
                iconData: Icons.local_drink_outlined,
                isEnabled: true,
              ),
              SizedBox(height: 10),
              CustomBooleanWidget(
                value: _smokes ?? false,
                onChanged: (value) => setState(() => _smokes = value),
                labelText: "Do you smoke?",
                iconData: Icons.smoking_rooms_outlined,
                isEnabled: true,
              ),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _professionController,
                  labelText: "Profession",
                  iconData: Icons.work_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),

              SizedBox(height: 10),
              CustomSelectFieldWidget<String>(
                  selectedValue: selectedLivingSituationOption,
                  options: [
                    "Own a house",
                    "Own an apartment",
                    "Rent a house",
                    "Rent an apartment",
                    "Rent with roommate",
                    "With my parents",
                    "Other",
                  ],
                  labelText: "Living Situation",
                  iconData: Icons.home_outlined,
                  onChanged: (value) {
                    setState(() {
                      selectedLivingSituationOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomBooleanWidget(
                value: _haveChildren ?? false,
                onChanged: (value) => setState(() => _haveChildren = value),
                labelText: "Do you have children?",
                iconData: Icons.child_care_outlined,
                isEnabled: true,
              ),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _noOfChildrenController,
                  labelText: "Number of Children",
                  iconData: Icons.child_friendly_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),

                          CustomSelectFieldWidget<String>(
                  selectedValue: selectedEmploymentStatusOption,
                  options: [
                    "Own a business",
                    "Full time employee",
                    "Part time employee",
                    "Student",
                    "Unemployed",
                    "Other",
                  ],
                  labelText: "Employment Status",
                  iconData: Icons.business_center_outlined,
                  onChanged: (value) {
                    setState(() {
                      selectedEmploymentStatusOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),

              CustomTextFieldWidget(
                  editingController: _incomeController,
                  labelText: "Income per year in {\$}",
                  iconData: Icons.money_outlined,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true), // Allow decimal input
                  inputFormatters: [
                    // Allow only digits and the decimal point with up to 2 decimal places
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomBooleanWidget(
                value: _willingToRelocate ?? false,
                onChanged: (value) =>
                    setState(() => _willingToRelocate = value),
                labelText: "Willing to Relocate?",
                iconData: Icons.location_on_outlined,
                isEnabled: true,
              ),

              SizedBox(height: 10),
              CustomSelectFieldWidget<String>(
                  selectedValue: selectedrelationshipLookingForOption,
                  options: [
                    "Marriage",
                    "Engagement",
                    "Friendship",
                    "Love",
                    "Other",
                  ],
                  labelText: "Relationship You Are Looking For",
                  iconData: Icons.favorite_outline,
                  onChanged: (value) {
                    setState(() {
                      selectedrelationshipLookingForOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),

              // Background
              SizedBox(height: 20),
              Text("Background",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _nationalityController,
                  labelText: "Nationality",
                  iconData: Icons.flag_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomSelectFieldWidget<String>(
                  selectedValue: selectedEducationOption,
                  options: [
                    'Preschool ',
                    'Primary',
                    'Lower Secondary ',
                    'Upper Secondary ',
                    'Vocational Education and Training',
                    'Associate’s Degree',
                    'Bachelor’s Degree',
                    'Master’s Degree',
                    'Doctoral Degree (Ph.D.)',
                    'Postdoctoral Research',
                    'Adult Education ',
                  ],
                  labelText: 'Education',
                  iconData: Icons.school_outlined,
                  onChanged: (value) {
                    setState(() {
                      selectedEducationOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 20),

              CustomTextFieldWidget(
                  editingController: _languageSpokenController,
                  labelText: "Languages Spoken",
                  iconData: Icons.language_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _religionController,
                  labelText: "Religion",
                  iconData: Icons.self_improvement_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),
              SizedBox(height: 10),
              CustomTextFieldWidget(
                  editingController: _ethnicityController,
                  labelText: "Ethnicity",
                  iconData: Icons.palette_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }),

              // Save and Proceed Button
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitProfile,
                  child: isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text("Save and Proceed"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

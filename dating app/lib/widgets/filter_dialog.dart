import 'package:flutter/material.dart';
import '../widgets/filter_drop_down.dart';
import '../widgets/filter_check_box.dart';

class FilterDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterDialog({Key? key, required this.onApplyFilters})
      : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _gender;
  String? _selectedBodyType;
  String? _selectedEducation;
  String? _selectedEmploymentStatus;
  String? _selectedRelationshipLookingFor;
  String? _selectedLivingSituation;
  bool? _drinks;
  bool? _smokes;

  final List<String> gender = [
    "Male",
    "Female",
    "Other",
  ];
  final List<String> bodyTypes = [
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
  List<String> employmentStatus = [
    "Own a business",
    "Full time employee",
    "Part time employee",
    "Student",
    "Unemployed",
    "Other",
  ];
  List<String> relationshipLookingFor = [
    "Marriage",
    "Engagement",
    "Friendship",
    "Love",
    "Other",
  ];
  List<String> livingSituation = [
    "Own a house",
    "Own an apartment",
    "Rent a house",
    "Rent an apartment",
    "Rent with roommate",
    "With my parents",
    "Other",
  ];
  final List<String> educationLevels = [
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
  ];

  @override
  Widget build(BuildContext context) {
     return AlertDialog(
      title: const Text('Filter Profiles'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repeated widget for each range slider and dropdown

            FilterDropdown(
                title: 'gender',
                value: _gender,
                items: gender,
                onChanged: (value) => setState(() => _gender = value)),
            FilterDropdown(
                title: 'Body Type',
                value: _selectedBodyType,
                items: bodyTypes,
                onChanged: (value) =>
                    setState(() => _selectedBodyType = value)),
            FilterDropdown(
                title: 'Education',
                value: _selectedEducation,
                items: educationLevels,
                onChanged: (value) =>
                    setState(() => _selectedEducation = value)),
            FilterDropdown(
                title: 'living Situation',
                value: _selectedLivingSituation,
                items: livingSituation,
                onChanged: (value) =>
                    setState(() => _selectedLivingSituation = value)),
            FilterDropdown(
                title: 'Employment Status',
                value: _selectedEmploymentStatus,
                items: employmentStatus,
                onChanged: (value) =>
                    setState(() => _selectedEmploymentStatus = value)),
            FilterDropdown(
                title: 'Relationship looking for',
                value: _selectedRelationshipLookingFor,
                items: relationshipLookingFor,
                onChanged: (value) =>
                    setState(() => _selectedRelationshipLookingFor = value)),

            FilterCheckbox(
                title: 'Drinks',
                value: _drinks,
                onChanged: (value) => setState(() => _drinks = value)),
            FilterCheckbox(
                title: 'Smokes',
                value: _smokes,
                onChanged: (value) => setState(() => _smokes = value)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final filters = {
              'gender': _gender,
              'body_type': _selectedBodyType,
              'education': _selectedEducation,
              'living_situation': _selectedLivingSituation,
              'Employment_status': _selectedEmploymentStatus,
              'relationship_looking_for': _selectedRelationshipLookingFor,
              'drinks': _drinks,
              'smokes': _smokes,
            };
            print('Filters applied:');
            filters.forEach((key, value) {
              print('$key: $value');
            });
            widget.onApplyFilters(filters);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

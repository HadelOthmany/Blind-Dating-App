import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String title;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const FilterDropdown({
    Key? key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: title),
          value: value,
          items: items
              .map((String type) =>
                  DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

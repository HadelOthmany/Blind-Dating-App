import 'package:flutter/material.dart';

class FilterCheckbox extends StatelessWidget {
  final String title;
  final bool? value;
  final Function(bool?) onChanged;

  const FilterCheckbox({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      tristate: true,
      onChanged: onChanged,
    );
  }
}

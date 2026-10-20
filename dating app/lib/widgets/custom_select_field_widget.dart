import 'package:flutter/material.dart';

class CustomSelectFieldWidget<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> options;
  final String? labelText;
  final IconData? iconData;
  final String? assetRef;
  final String? Function(T?)? validator;
  final ValueChanged<T?>? onChanged;

  const CustomSelectFieldWidget({
    Key? key,
    this.selectedValue,
    required this.options,
    this.labelText,
    this.iconData,
    this.assetRef,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: iconData != null
            ? Icon(iconData)
            : assetRef != null
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(assetRef!),
                  )
                : null,
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      items: options.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}

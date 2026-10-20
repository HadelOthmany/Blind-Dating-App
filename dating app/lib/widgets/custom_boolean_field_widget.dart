import 'package:flutter/material.dart';

class CustomBooleanWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;
  final bool isEnabled;

  const CustomBooleanWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (iconData != null)
          Icon(
            iconData,
            color: isEnabled ? Colors.black : Colors.grey,
          )
        else if (assetRef != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              assetRef!,
              color: isEnabled ? null : Colors.grey,
            ),
          ),
        if (labelText != null)
          Text(
            labelText!,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: isEnabled ? onChanged : null,
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}

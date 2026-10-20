import 'package:flutter/material.dart';
import '../services/country_service.dart';
import 'custom_select_field_widget.dart';

class CountryDropdown extends StatefulWidget {
  final String? initialCountry;
  final ValueChanged<String?> onCountrySelected;

  const CountryDropdown({
    Key? key,
    this.initialCountry,
    required this.onCountrySelected,
  }) : super(key: key);

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  String? _selectedCountry;
  late Future<List<String>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    _countriesFuture = CountryService().fetchCountries();
    _selectedCountry = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _countriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No countries found');
        } else {
          List<String> countries = snapshot.data!;
          return CustomSelectFieldWidget<String>(
            labelText: 'Country',
            iconData: Icons.flag_outlined,
            selectedValue: _selectedCountry,
            options: countries,
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
              });
              widget.onCountrySelected(value);
            },
          );
        }
      },
    );
  }
}

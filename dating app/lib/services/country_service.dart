import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  Future<List<String>> fetchCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3/all'));

    if (response.statusCode == 200) {
      final List countriesData = json.decode(response.body);
      // Extract country names
      List<String> countries = countriesData
          .map((country) => country['name']['common'] as String)
          .toList();
      return countries;
    } else {
      throw Exception('Failed to load countries');
    }
  }
}

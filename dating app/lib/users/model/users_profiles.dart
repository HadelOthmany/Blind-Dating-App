import 'dart:convert';
import 'package:http/http.dart' as http;

class Person {
  int? id;
  String? gender;
  String? name;
  String? email;
  String? phone_no;
  String? city;
  String? country;
  String? profile_heading;
  String? looking_for_partner;
  String? height;
  String? weight;
  String? body_type;
  String? profession;
  String? living_situation;
  int? willing_to_relocate;
  String? relationship_looking_for;
  String? nationality;
  String? education;
  String? languages_spoken;
  String? religion;
  String? ethnicity;
  String? birthdate;
  int? drinks;
  int? smokes;
  int? have_children;
  String? no_of_children;
  String? employment_status;
  String? income;

  // Constructor
  Person({
    this.id,
    this.gender,
    this.name,
    this.email,
    this.phone_no,
    this.city,
    this.country,
    this.profile_heading,
    this.looking_for_partner,
    this.height,
    this.weight,
    this.body_type,
    this.profession,
    this.living_situation,
    this.willing_to_relocate,
    this.relationship_looking_for,
    this.nationality,
    this.education,
    this.languages_spoken,
    this.religion,
    this.ethnicity,
    this.birthdate,
    this.drinks,
    this.smokes,
    this.have_children,
    this.no_of_children,
    this.employment_status,
    this.income,
  });

  static Future<List<Person>> getAllUsersExceptLoggedIn(
      String loggedInUserId) async {
    final response = await http.get(Uri.parse(
        'http://10.211.55.4/datingpro/get_all_users.php?logged_in_user_id=$loggedInUserId'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Person> users = [];

      for (var userData in data) {
        users.add(Person(
          id: userData['id'],
          name: userData['name'],
          gender: userData['gender'],
          email: userData['email'],
          phone_no: userData['phone_no'],
          city: userData['city'],
          country: userData['country'],
          profile_heading: userData['profile_heading'],
          looking_for_partner: userData['looking_for_partner'],
          height: userData['height'],
          weight: userData['weight'],
          body_type: userData['body_type'],
          profession: userData['profession'],
          living_situation: userData['living_situation'],
          willing_to_relocate: userData['willing_to_relocate'],
          relationship_looking_for: userData['relationship_looking_for'],
          nationality: userData['nationality'],
          education: userData['education'],
          languages_spoken: userData['languages_spoken'],
          religion: userData['religion'],
          ethnicity: userData['ethnicity'],
          birthdate: userData['birthdate'],
          drinks: userData['drinks'],
          smokes: userData['smokes'],
          have_children: userData['have_children'],
          no_of_children: userData['no_of_children'],
          employment_status: userData['employment_status'],
          income: userData['income'],
        ));
      }

      return users;
    } else {
      throw Exception('Failed to load user profiles');
    }
  }

  static Future<Person?> fromDatabase(String userId) async {
    final response = await http.get(Uri.parse(
        'http://10.211.55.4/datingpro/fetch_person.php?user_id=$userId'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["error"] != null) {
        print(data["error"]);
        return null;
      } else {
        print("Fetched Data: $data");
        return Person(
          id: data['id'],
          gender: data['gender'],
          name: data['name'],
          email: data['email'],
          phone_no: data['phone_no'],
          city: data['city'],
          country: data['country'],
          profile_heading: data['profile_heading'],
          looking_for_partner: data['looking_for_partner'],
          height: data['height'],
          weight: data['weight'],
          body_type: data['body_type'],
          profession: data['profession'],
          living_situation: data['living_situation'],
          willing_to_relocate: data['willing_to_relocate'],
          relationship_looking_for: data['relationship_looking_for'],
          nationality: data['nationality'],
          education: data['education'],
          languages_spoken: data['languages_spoken'],
          religion: data['religion'],
          ethnicity: data['ethnicity'],
          birthdate: data['birthdate'],
          drinks: data['drinks'],
          smokes: data['smokes'],
          have_children: data['have_children'],
          no_of_children: data['no_of_children'],
          employment_status: data['employment_status'],
          income: data['income'],
        );
      }
    } else {
      print('Failed to load data');
      return null;
    }
  }

  static Future<List<Person>> getFilteredUsers(
      String loggedInUserId, Map<String, dynamic> filters) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.16/datingpro/get_filtered_users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': loggedInUserId,
          'filters': {
            'gender': filters['gender'],
            'body_type': filters['body_type'],
            'education': filters['education'],
            'living_situation': filters['living_situation'],
            'Employment_status': filters['Employment_status'],
            'relationship_looking_for': filters['relationship_looking_for'],
            'drinks': filters['drinks'],
            'smokes': filters['smokes'],
          },
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<Person> users = [];

        for (var userData in data) {
          users.add(Person(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
            phone_no: userData['phone_no'],
            city: userData['city'],
            country: userData['country'],
            profile_heading: userData['profile_heading'],
            looking_for_partner: userData['looking_for_partner'],
            height: userData['height'],
            weight: userData['weight'],
            body_type: userData['body_type'],
            profession: userData['profession'],
            living_situation: userData['living_situation'],
            willing_to_relocate: userData['willing_to_relocate'],
            relationship_looking_for: userData['relationship_looking_for'],
            nationality: userData['nationality'],
            education: userData['education'],
            languages_spoken: userData['languages_spoken'],
            religion: userData['religion'],
            ethnicity: userData['ethnicity'],
            birthdate: userData['birthdate'],
            drinks: userData['drinks'],
            smokes: userData['smokes'],
            have_children: userData['have_children'],
            no_of_children: userData['no_of_children'],
            employment_status: userData['employment_status'],
            income: userData['income'],
          ));
        }

        return users;
      } else {
        throw Exception('Failed to load filtered profiles');
      }
    } catch (e) {
      print('Error fetching filtered users: $e');
      throw Exception('Failed to load filtered profiles');
    }
  }

}



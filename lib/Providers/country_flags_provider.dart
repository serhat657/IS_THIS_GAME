import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Bayrak ve ülke isimlerini çeken fonksiyon
Future<List<Map<String, String>>> fetchCountryFlagsAndNames() async {
  final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

  if (response.statusCode == 200) {
    List countries = json.decode(response.body);
    List<Map<String, String>> flagsAndNames = countries.map<Map<String, String>>((country) {
      if (country['flags'] != null && country['flags']['png'] != null && country['name']['common'] != null) {
        return {
          'flag': country['flags']['png'],
          'name': country['name']['common']
        };
      } else {
        return {};
      }
    }).where((element) => element.isNotEmpty).toList();

    return flagsAndNames;
  } else {
    throw Exception('Failed to load country flags and names');
  }
}

// FutureProvider ile bayrakları ve isimleri sağlama
final countryFlagsAndNamesProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  return fetchCountryFlagsAndNames();
});

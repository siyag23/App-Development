import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallpaper.dart';

class ApiClient {
  final String apiKey = 'Sc43daBtVDWnf7pFmpTX84GUbdWdOzgOrNuc138ynHVnz50Nw60ztKWp'; // Replace with your actual API key

  Future<List<Wallpaper>> fetchWallpapers() async {
    const url = 'https://api.pexels.com/v1/search?query=nature&per_page=20&page=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List photos = data['photos'];
      return photos.map((json) => Wallpaper.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wallpapers: ${response.statusCode}');
    }
  }
}

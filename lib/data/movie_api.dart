import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApi {
  static const String _apiKey = "c7bb98eac6e219a1992f73a38c5a25b7";
  static const String _baseUrl = "https://api.themoviedb.org/3";

  // 📌 Fetch popular movies
  static Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/movie/popular?api_key=$_apiKey"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List movies = data["results"];
      return movies.map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception("Failed to fetch movies");
    }
  }

  // 📌 Search movies
  static Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/search/movie?api_key=$_apiKey&query=$query"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List movies = data["results"];
      return movies.map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception("Failed to search movies");
    }
  }

  // 📌 Fetch trailer link (YouTube)
  static Future<String?> getMovieTrailer(int movieId) async {
    final response = await http.get(Uri.parse(
        "$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=en-US"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data["results"] as List;

      final trailer = results.cast<Map<String, dynamic>>().firstWhere(
        (video) => video["type"] == "Trailer" && video["site"] == "YouTube",
        orElse: () => <String, dynamic>{}, // ✅ safe fallback
      );

      if (trailer.isNotEmpty) {
        return "https://www.youtube.com/watch?v=${trailer["key"]}";
      }
    }
    return null;
  }
}

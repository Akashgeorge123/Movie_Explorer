import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String? releaseDate;
  final double? rating;
  final String? overview;

  Movie( {
    required this.id,
    required this.title,
    required this.posterPath,
    this.releaseDate,
    this.rating,
    this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"] ?? 0,
      title: json["title"] ?? "Unknown",
      posterPath: json["poster_path"] ?? "",
      releaseDate: json["release_date"],
      rating: (json["vote_average"] != null)
          ? (json["vote_average"] as num).toDouble()
          : null,
      overview: json["overview"],
    );
  }

  String get posterUrl =>
      posterPath.isNotEmpty
          ? "https://image.tmdb.org/t/p/w500$posterPath"
          : "";

  /// Fetch trailer key from TMDb
  Future<String?> getTrailerKey(String apiKey) async {
    final url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$id/videos?api_key=$apiKey&language=en-US");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data["results"] as List;
      final trailer = results.firstWhere(
        (v) => v["type"] == "Trailer" && v["site"] == "YouTube",
        orElse: () => null,
      );
      return trailer?["key"];
    } else {
      return null;
    }
  }
}

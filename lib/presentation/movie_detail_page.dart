import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../models/movie.dart';
import '../../../data/movie_api.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  YoutubePlayerController? _youtubeController;
  bool _showTrailer = false;
  bool _loadingTrailer = false;

  Future<void> _playTrailer() async {
    setState(() => _loadingTrailer = true);

    try {
      final trailerUrl = await MovieApi.getMovieTrailer(widget.movie.id);

      if (trailerUrl == null) {
        if (!mounted) return;
        setState(() => _loadingTrailer = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No trailer available 😢")),
        );
        return;
      }

      final videoId = YoutubePlayer.convertUrlToId(trailerUrl);
      if (videoId == null) {
        if (!mounted) return;
        setState(() => _loadingTrailer = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid trailer link 😢")),
        );
        return;
      }

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      if (!mounted) return;
      setState(() {
        _showTrailer = true;
        _loadingTrailer = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingTrailer = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading trailer: $e")),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🎬 Poster or Trailer
            if (_loadingTrailer)
              const SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.pink),
                ),
              )
            else if (_showTrailer && _youtubeController != null)
              YoutubePlayer(controller: _youtubeController!)
            else
              Stack(
                children: [
                  Image.network(
                    widget.movie.posterUrl,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _playTrailer,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Watch Trailer"),
                    ),
                  ),
                ],
              ),

            // 📃 Movie details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Release Date: ${widget.movie.releaseDate ?? "N/A"}"),
                  const SizedBox(height: 10),
                  Text("⭐ Rating: ${widget.movie.rating?.toStringAsFixed(1) ?? "N/A"}"),
                  const SizedBox(height: 15),
                  Text(widget.movie.overview ?? "No description available."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

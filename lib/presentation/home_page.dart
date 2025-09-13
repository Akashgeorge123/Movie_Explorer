import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_explorer/presentation/movie_detail_page.dart';
import '../../../data/movie_api.dart';
import '../../../models/movie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  bool _loading = true;
  int _currentIndex = 0; // track carousel index

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      final movies = await MovieApi.getPopularMovies();
      if (!mounted) return;
      setState(() {
        _movies = movies;
        _filteredMovies = movies;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredMovies = _movies);
      return;
    }
    try {
      final results = await MovieApi.searchMovies(query);
      if (!mounted) return;
      setState(() => _filteredMovies = results);
    } catch (e) {
      // ignore silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : Stack(
              children: [
                // 🔹 Dynamic background
                if (_filteredMovies.isNotEmpty)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      key: ValueKey<int>(_currentIndex),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _filteredMovies[_currentIndex].posterUrl.isNotEmpty
                              ? NetworkImage(_filteredMovies[_currentIndex].posterUrl)
                              : const AssetImage('assets/images/Movie-explorer.png') as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.6), BlendMode.darken),
                        ),
                      ),
                    ),
                  ),

                // 🔹 Foreground content
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Search bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _searchMovies,
                            decoration: InputDecoration(
                              hintText: "Search movies 🎀",
                              prefixIcon: const Icon(Icons.search, color: Colors.pink),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Carousel & info
                        if (_filteredMovies.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 200),
                            child: Center(child: Text("No movies found 😢", style: TextStyle(color: Colors.white, fontSize: 18))),
                          )
                        else
                          Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: _filteredMovies.length,
                                options: CarouselOptions(
                                  height: 400,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.easeInOut,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration: const Duration(seconds: 2),
                                  viewportFraction: 0.7,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                itemBuilder: (context, index, realIndex) {
                                  final movie = _filteredMovies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MovieDetailsPage(movie: movie),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: movie.posterUrl.isNotEmpty
                                          ? Image.network(
                                              movie.posterUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Image.asset('assets/images/Movie-explorer.png', fit: BoxFit.cover),
                                            )
                                          : Image.asset('assets/images/Movie-explorer.png', fit: BoxFit.cover),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              // Dynamic movie info
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    Text(
                                      _filteredMovies[_currentIndex].title,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < (_filteredMovies[_currentIndex].rating ?? 0).round()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.yellow,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _filteredMovies[_currentIndex].overview ?? "No description available.",
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_movies_provider/providers/movie_provider.dart';
import 'package:my_movies_provider/search/serach_delegate.dart';
import 'package:my_movies_provider/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas en cine"),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: SearchMovieDelegate(),
            ),
            icon: const Icon(
              Icons.search_outlined,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(
              movies: moviesProvider.onDisplayMovies,
            ),
            MovieSlider(
              movies: moviesProvider.onDisplayMoviesPopular,
              onNetxPage: (page) => moviesProvider.getMoviesPopular(page),
            ),
          ],
        ),
      ),
    );
  }
}

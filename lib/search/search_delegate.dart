import 'package:flutter/material.dart';
import 'package:my_movies_provider/models/movie.dart';
import 'package:my_movies_provider/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class SearchMovieDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 130,
        ),
      );
    }

    final moviesProvider =
        Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No encontramos tu película...'),
                Icon(Icons.search_off_rounded)
              ],
            ),
          );
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return _MovieItem(movie: movies[index]);
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'seaarch-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: movie.posterPath.isNotEmpty
              ? NetworkImage(movie.getFullPosterPath())
              : const AssetImage("assets/no-image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text('${movie.voteCount.toString()} votos'),
      onTap: () =>
          Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}

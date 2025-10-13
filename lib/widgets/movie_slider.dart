import 'package:flutter/material.dart';
import 'package:my_movies_provider/models/movie.dart';
import 'package:my_movies_provider/widgets/zoom_context_menu_card.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider({
    super.key,
    required this.movies,
    required this.onNetxPage,
  });

  final List<Movie> movies;
  final Function(int) onNetxPage;

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        page = page + 1;
        widget.onNetxPage(page);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TitleSlider(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, index) {
                final movie = widget.movies[index];
                return _MoviePoster(movie: movie);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _TitleSlider extends StatelessWidget {
  const _TitleSlider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Populares",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'slider-${movie.id}';
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ZoomContextMenuCard(
        menuOptions: [
          MenuOption(
            'Eliminar',
            Icons.delete_forever_outlined,
            () {
              print('Eliminar elemento');
            },
          ),
          MenuOption(
            'Ocultar',
            Icons.visibility_off_outlined,
            () {
              print('Ocultar elemento');
            },
          )
        ],
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'details',
                  arguments: movie,
                );
              },
              child: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder:
                        const AssetImage("assets/no-image.jpg"),
                    image: movie.posterPath.isNotEmpty
                        ? NetworkImage(movie.getFullPosterPath())
                        : const AssetImage("assets/no-image.jpg"),
                    fit: BoxFit.cover,
                    width: 130,
                    height: 190,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

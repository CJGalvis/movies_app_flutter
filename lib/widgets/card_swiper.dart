import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:my_movies_provider/models/movie.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: Swiper(
          itemCount: movies.length,
          layout: SwiperLayout.STACK,
          itemHeight: size.width * 0.9,
          itemWidth: size.width * 0.6,
          itemBuilder: (context, index) {
            final movie = movies[index];
            movie.heroId = 'swiper-${movie.id}';
            return GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              child: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/no-image.jpg"),
                    image: NetworkImage(movie.getFullPosterPath()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}

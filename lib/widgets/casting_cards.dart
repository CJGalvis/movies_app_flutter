import 'package:flutter/material.dart';
import 'package:my_movies_provider/models/casting_response.dart';
import 'package:my_movies_provider/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  const CastingCards({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    final moviesProvider =
        Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getCasting(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (BuildContext contex, int index) =>
                _CastCard(
              actor: cast[index],
            ),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.actor});

  final Cast actor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage("assets/no-image.jpg"),
              image: actor.profilePath.isNotEmpty
                  ? NetworkImage(actor.getFullProfile())
                  : const AssetImage("assets/no-image.jpg"),
              fit: BoxFit.cover,
              height: 140,
              width: 100,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_movies_provider/helpers/debouncer.dart';
import 'package:my_movies_provider/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '37ad28b4ed078056ad29243a84645a3f';
  final String _languaje = 'es-ES';
  final int page = 1;

  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayMoviesPopular = [];
  Map<int, List<Cast>> onDisplayCasting = {};

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionsStremCtrl =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => _suggestionsStremCtrl.stream;

  MoviesProvider() {
    getMovies();
    getMoviesPopular(page);
  }

  dynamic _getData(String endpoint, {int page = 1}) async {
    var url = Uri.https(_baseUrl, '3/$endpoint', {
      'language': _languaje,
      'api_key': _apiKey,
      'page': '$page',
    });

    final response = await http.get(url);
    return response;
  }

  void getMovies() async {
    final response = await _getData('movie/now_playing');
    final data = MoviesResponse.fromJson(json.decode(response.body));
    onDisplayMovies = data.results;
    notifyListeners();
  }

  void getMoviesPopular(int pagination) async {
    final response = await _getData('movie/popular', page: pagination);
    final data = PopularResponse.fromJson(json.decode(response.body));
    onDisplayMoviesPopular = [...onDisplayMoviesPopular, ...data.results];
    notifyListeners();
  }

  Future<List<Cast>> getCasting(int movieId) async {
    if (onDisplayCasting.containsKey(movieId)) {
      return onDisplayCasting[movieId]!;
    }

    final response = await _getData('movie/$movieId/credits');
    final data = CastingResponse.fromJson(json.decode(response.body));
    onDisplayCasting[movieId] = data.cast;
    return data.cast;
  }

  Future<List<Movie>> getMoviesByQuery(String query) async {
    var url = Uri.https(_baseUrl, '3/search/movie', {
      'language': _languaje,
      'api_key': _apiKey,
      'query': query,
    });
    final response = await http.get(url);
    final data = QueryMovieResponse.fromJson(json.decode(response.body));
    return data.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      final results = await getMoviesByQuery(query);
      _suggestionsStremCtrl.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 203000), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 3001)).then((_) {
      timer.cancel();
    });
  }
}

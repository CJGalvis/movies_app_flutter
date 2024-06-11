import 'dart:convert';

import 'package:my_movies_provider/models/movie.dart';

QueryMovieResponse queryMovieResponseFromJson(String str) =>
    QueryMovieResponse.fromJson(json.decode(str));

String queryMovieResponseToJson(QueryMovieResponse data) =>
    json.encode(data.toJson());

class QueryMovieResponse {
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  QueryMovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory QueryMovieResponse.fromJson(Map<String, dynamic> json) =>
      QueryMovieResponse(
        page: json["page"],
        results:
            List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

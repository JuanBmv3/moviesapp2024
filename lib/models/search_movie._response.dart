import 'dart:convert';

import 'package:peliculasapp/models/models.dart';

class SearchMovie {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    SearchMovie({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory SearchMovie.fromJson(String str) => SearchMovie.fromMap(json.decode(str));

    factory SearchMovie.fromMap(Map<String, dynamic> json) => SearchMovie(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}


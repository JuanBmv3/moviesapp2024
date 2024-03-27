import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculasapp/helpers/debounder.dart';
import 'package:peliculasapp/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  List<Movie> resultsMoviesNowPlaying = [];
  List<Movie> resultsPopularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  final String _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjQ3YTI0Yjk5ZWJmZWZiNTFlOGEzMmUzNTVmNzQzMSIsInN1YiI6IjY2MDMxMGEzNjA2MjBhMDEzMDI2MDZjOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4hYSVvOLlGsa8bLCgVep5dV5AN3kfms2ThsbguPycFg';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  Future<String> _getJsonData(String enpoint, [int page = 1]) async{
     final url = Uri.https(_baseUrl , enpoint, {
      'language': _language,
      'page': '$page'
    });

    final res = await http.get(url, headers: {
      'content-type': "application/json",
      'Authorization': 'Bearer $_apiKey', // Incluye el token en el encabezado 'Authorization'
    }); 

    return res.body;
  }

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovie();
  }

  getOnDisplayMovies() async{


    final nowPlayingResponse = NowPlayingResponse.fromJson(await _getJsonData('3/movie/now_playing'));

    resultsMoviesNowPlaying = nowPlayingResponse.results;
    notifyListeners();

  }

  getPopularMovie() async{

    _popularPage++;
  
    final popularMoviesResponse = PopularMoviesResponse.fromJson(await _getJsonData('3/movie/popular', _popularPage));

    resultsPopularMovies = [...resultsPopularMovies, ...popularMoviesResponse.results];
    
    notifyListeners();
  }

  Future<List<Cast>> getMoviesCast(int movieId) async{

    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final castResponse = CastResponse.fromJson( await _getJsonData('3/movie/$movieId/credits'));
    moviesCast[movieId] = castResponse.cast;

    return castResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async{
    final url = Uri.https(_baseUrl , '3/search/movie', {
      'language': _language,
      'query' : query
    });

    final res = await http.get(url, headers: {
      'content-type': "application/json",
      'Authorization': 'Bearer $_apiKey', // Incluye el token en el encabezado 'Authorization'
    }); 

    final searchResponse = SearchMovie.fromJson(res.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value ) async{

    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
     });

     Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
    

}
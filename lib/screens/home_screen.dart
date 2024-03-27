import 'package:flutter/material.dart';
import 'package:peliculasapp/providers/providers.dart';
import 'package:peliculasapp/search/search_delegate.dart';
import 'package:peliculasapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

  final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: const Icon(Icons.search, color: Colors.white,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            CardSwiper(movies: moviesProvider.resultsMoviesNowPlaying),
        
            MovieSlider(
              movies: moviesProvider.resultsPopularMovies,
              title: 'Populares', 
              onNextPage: () => moviesProvider.getPopularMovie(),
             ),
          ],
        ),
      )
    );
  }
}
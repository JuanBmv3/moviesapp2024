import 'package:flutter/material.dart';
import 'package:peliculasapp/providers/movie_provider.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        },
        icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return _emptyContainer();
    }
    
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (context, AsyncSnapshot<List<Movie>> snapshot ){
        if(!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => MovieItem(movie: movies[index],)
          );
      }
    );
  }

  Widget _emptyContainer(){
    return const Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130),
      );
  }

}

class MovieItem extends StatelessWidget {

  final Movie movie;

  const MovieItem({
    super.key, required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    movie.imageHeroId = "search-${movie.id}";

    return ListTile(
      leading: Hero(
        tag: movie.imageHeroId!,
        child: FadeInImage(
          placeholder: const NetworkImage('https://via.placeholder.com/300x400'),
          image: NetworkImage(movie.fullPosterImg),
          fit: BoxFit.contain,
          width: 100 ,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap : () => Navigator.pushNamed(context, 'details', arguments: movie)
    );
  }
}
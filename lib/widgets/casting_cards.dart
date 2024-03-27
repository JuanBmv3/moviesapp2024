import 'package:flutter/cupertino.dart';
import 'package:peliculasapp/models/models.dart';
import 'package:peliculasapp/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {
  final int movieId;
  const CastingCard({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMoviesCast(movieId), 
      builder: (_, AsyncSnapshot<List<Cast>> snapshot){

        if(!snapshot.hasData){
          return Container(
            constraints: const BoxConstraints(minWidth: 150),
            height: 180,
            width: 100,
            child: const CupertinoActivityIndicator(),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(cast: cast[index]),
            itemCount: cast.length,
            ),
        );
      }
    );

    
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;
  const _CastCard({
    super.key, required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const NetworkImage('https://via.placeholder.com/200x300'),
              image: NetworkImage(cast.fullProfilePath),
              height: 140,
              width: 400,
              fit: BoxFit.cover
            )
          ),
          const SizedBox(height: 5,),
          Text(cast.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,),
          const SizedBox(height: 3,), 
          Text(cast.character == null || cast.character == '' ? '' : cast.character!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),)
        ],
      ),
    );
  }
}
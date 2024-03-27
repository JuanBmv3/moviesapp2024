import 'package:flutter/material.dart';
import 'package:peliculasapp/models/movie.dart';
import 'package:peliculasapp/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie),
          SliverList(
            delegate: SliverChildListDelegate ([
              _PosterAndTitle(movie: movie),
              const SizedBox(height: 15,),
              _Overview(movie: movie),

              const SizedBox(height: 15,),

              CastingCard(movieId: movie.id) 
            ])
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  
  final Movie movie;
  
  const _CustomAppBar({super.key, required this.movie});
  

  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      iconTheme: const IconThemeData(
        color: Colors.white
      ),
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          width: double.infinity,
          color: Colors.black12,
          alignment: Alignment.bottomCenter,
          child: Text(movie.title, style: const TextStyle(fontSize: 20,), textAlign: TextAlign.center,)
        ),
        background: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 10, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: FadeInImage(
            placeholder: const NetworkImage('https://www.icegif.com/wp-content/uploads/2023/07/icegif-1262.gif'), 
            image: NetworkImage(movie.fullBackdropPath),
            fit: BoxFit.cover,
          ),
        ),

      ),
    );
  }
}

class _PosterAndTitle  extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.imageHeroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const NetworkImage('https://via.placeholder.com/200x300'),
                image: NetworkImage(movie.fullPosterImg),
                height: 200,
              ),
              
            ),
          ),

          const SizedBox(width: 5,),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 230),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                Text(movie.originalTitle, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis, maxLines: 3,),
                
                const SizedBox(height: 10,),
                
                Row(
                  children: [
                    const Icon(Icons.star_rate, size: 20, color: Colors.grey,),
                    
                    Text(movie.voteAverage.toStringAsPrecision(2), style: Theme.of(context).textTheme.bodyMedium,)
                  ],
                )
              ],        
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(movie.overview,
      style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.justify,),
    );
  }
}
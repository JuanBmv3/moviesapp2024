import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;
  const MovieSlider({super.key, required this.movies, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    
    scrollController.addListener(() { 
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
        widget.onNextPage();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          widget.title == null 
            ? Container()
            : const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Populares', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            ),

          const SizedBox(height: 10,),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) =>  _MoviePoster(movie: widget.movies[index])
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster({super.key, required this.movie,});
  @override
  Widget build(BuildContext context) {

    movie.imageHeroId = 'swiper-${movie.title}';

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.imageHeroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:  FadeInImage(
                  placeholder: const NetworkImage('https://via.placeholder.com/300x400'), 
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 5,),

          Text(movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
          
        ],
      ),
    );
  }
}
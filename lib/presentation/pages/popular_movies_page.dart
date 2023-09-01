import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MoviePopularBloc>().add(FetchPopularMovie()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularBloc, MovieState>(
          builder: (context,state) {
            if (state is PopularMovieInitial || state is PopularMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMovieSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else if(state is PopularMovieError){
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }else{
              return Center(
                child: Text("ERR"),
              );
            }
          },
        ),
      ),
    );
  }
}

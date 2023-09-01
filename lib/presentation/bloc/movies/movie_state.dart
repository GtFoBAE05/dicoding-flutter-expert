part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

//now playing
class NowPlayingMovieInitial extends MovieState {}

class NowPlayingMovieLoading extends MovieState {}

class NowPlayingMovieSuccess extends MovieState {
  final List<Movie> movies;

  NowPlayingMovieSuccess({required this.movies});
}

class NowPlayingMovieError extends MovieState {
  final String message;

  NowPlayingMovieError({required this.message});
}

//popular
class PopularMovieInitial extends MovieState {}

class PopularMovieLoading extends MovieState {}

class PopularMovieSuccess extends MovieState {
  final List<Movie> movies;

  PopularMovieSuccess({required this.movies});
}

class PopularMovieError extends MovieState {
  final String message;

  PopularMovieError({required this.message});
}

//detail
class DetailMovieInitial extends MovieState {}

class DetailMovieLoading extends MovieState {}

class DetailMovieSuccess extends MovieState {
  final MovieDetail movieDetail;

  DetailMovieSuccess({required this.movieDetail});
}

class DetailMovieError extends MovieState {
  final String message;

  DetailMovieError({required this.message});
}

//top rated
class TopRatedMovieInitial extends MovieState {}

class TopRatedMovieLoading extends MovieState {}

class TopRatedMovieSuccess extends MovieState {
  final List<Movie> movies;

  TopRatedMovieSuccess({required this.movies});
}

class TopRatedMovieError extends MovieState {
  final String message;

  TopRatedMovieError({required this.message});
}

//search
class SearchMovieInitial extends MovieState {}

class SearchMovieLoading extends MovieState {}

class SearchMovieSuccess extends MovieState {
  final List<Movie> movies;

  SearchMovieSuccess({required this.movies});
}

class SearchMovieError extends MovieState {
  final String message;

  SearchMovieError({required this.message});
}

//recommendation
class RecommendationMovieInitial extends MovieState {}

class RecommendationMovieLoading extends MovieState {}

class RecommendationMovieSuccess extends MovieState {
  final List<Movie> movies;

  RecommendationMovieSuccess({required this.movies});
}

class RecommendationMovieError extends MovieState {
  final String message;

  RecommendationMovieError({required this.message});
}

//watchlist
class WatchlistMovieInitial extends MovieState {}

class WatchlistMovieLoading extends MovieState {}

class WatchlistMovieSuccess extends MovieState {
  final List<Movie> movies;

  WatchlistMovieSuccess({required this.movies});
}

class WatchlistMovieError extends MovieState {
  final String message;

  WatchlistMovieError({required this.message});
}

class WatchlistMovieStatus extends MovieState {
  final bool value;

  const WatchlistMovieStatus({required this.value});
}

class WatchlistMovieMessage extends MovieState {
  final String message;

  const WatchlistMovieMessage({required this.message});
}

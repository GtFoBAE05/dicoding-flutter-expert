part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}


class FetchNowPlayingMovie extends MovieEvent {}

class FetchPopularMovie extends MovieEvent {}

class FetchTopRatedMovie extends MovieEvent {}

class FetchMovieDetail extends MovieEvent {
  final int id;

  const FetchMovieDetail({required this.id});
}

class FetchSearchMovie extends MovieEvent {
  final String value;

  const FetchSearchMovie({required this.value});
}

class FetchMovieWatchlist extends MovieEvent {}

class FetchMovieWatchlistStatus extends MovieEvent {
  final int id;

  const FetchMovieWatchlistStatus({required this.id});
}

class FetchMovieRecommendation extends MovieEvent {
  final int id;

  const FetchMovieRecommendation({required this.id});
}


class AddMovieWatchlist extends MovieEvent {
  final MovieDetail movieDetail;

  const AddMovieWatchlist({required this.movieDetail});
}

class RemoveMovieWatchlist extends MovieEvent {
  final MovieDetail movieDetail;

  const RemoveMovieWatchlist({required this.movieDetail});

}


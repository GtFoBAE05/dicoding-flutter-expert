import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies _nowPlayingMovie;

  MovieNowPlayingBloc(this._nowPlayingMovie) : super(NowPlayingMovieInitial()) {
    on<FetchNowPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieLoading());

      final result = await _nowPlayingMovie.execute();

      result.fold((l) => emit(NowPlayingMovieError(message: l.message)),
          (r) => emit(NowPlayingMovieSuccess(movies: r)));
    });
  }
}

class MovieTopRatedBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  MovieTopRatedBloc(this._getTopRatedMovies) : super(TopRatedMovieInitial()) {
    on<FetchTopRatedMovie>((event, emit) async {
      emit(TopRatedMovieLoading());

      final result = await _getTopRatedMovies.execute();

      result.fold((l) => emit(TopRatedMovieError(message: l.message)),
          (r) => emit(TopRatedMovieSuccess(movies: r)));
    });
  }
}

class MoviePopularBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies _getPopularMovies;

  MoviePopularBloc(this._getPopularMovies) : super(PopularMovieInitial()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(PopularMovieLoading());

      final result = await _getPopularMovies.execute();

      result.fold((l) => emit(PopularMovieError(message: l.message)),
          (r) => emit(PopularMovieSuccess(movies: r)));
    });
  }
}

class MovieDetailBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(DetailMovieInitial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(DetailMovieLoading());

      final result = await _getMovieDetail.execute(event.id);

      result.fold((l) => emit(DetailMovieError(message: l.message)),
          (r) => emit(DetailMovieSuccess(movieDetail: r)));
    });
  }
}

class MovieSearchBloc extends Bloc<MovieEvent, MovieState> {
  final SearchMovies _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(SearchMovieInitial()) {
    on<FetchSearchMovie>((event, emit) async {
      emit(SearchMovieLoading());

      final result = await _searchMovies.execute(event.value);

      result.fold((l) => emit(SearchMovieError(message: l.message)),
          (r) => emit(SearchMovieSuccess(movies: r)));
    });
  }
}

class MovieRecommendationBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations) : super(RecommendationMovieInitial()) {
    on<FetchMovieRecommendation>((event, emit) async {
      emit(RecommendationMovieLoading());

      final result = await _getMovieRecommendations.execute(event.id);

      result.fold((l) => emit(RecommendationMovieError(message: l.message)),
              (r) => emit(RecommendationMovieSuccess(movies: r)));
    });
  }
}

class MovieWatchlistBloc extends Bloc<MovieEvent, MovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchlistMoviesStatus;
  final SaveWatchlist _saveWatchList;
  final RemoveWatchlist _removeWatchlist;

  MovieWatchlistBloc(this._getWatchlistMovies, this._getWatchlistMoviesStatus,
      this._saveWatchList, this._removeWatchlist)
      : super(NowPlayingMovieInitial()) {
    on<FetchMovieWatchlist>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold((l) => emit(WatchlistMovieError(message: l.message)),
          (r) => emit(WatchlistMovieSuccess(movies: r)));
    });

    on<FetchMovieWatchlistStatus>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await _getWatchlistMoviesStatus.execute(event.id);

      emit(WatchlistMovieStatus(value: result));
    });

    on<AddMovieWatchlist>((event, emit) async {
      final result = await _saveWatchList.execute(event.movieDetail);

      result.fold((l) => emit(WatchlistMovieError(message: l.message)),
          (r) => emit(WatchlistMovieMessage(message: r)));
    });

    on<RemoveMovieWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movieDetail);

      result.fold((l) => emit(WatchlistMovieError(message: l.message)),
          (r) => emit(WatchlistMovieMessage(message: r)));
    });
  }
}

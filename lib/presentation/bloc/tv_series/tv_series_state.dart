part of 'tv_series_bloc.dart';

abstract class TvSeriesState extends Equatable {
  const TvSeriesState();

  @override
  List<Object> get props => [];
}

//on air
class OnAirTvSeriesInitial extends TvSeriesState {}

class OnAirTvSeriesLoading extends TvSeriesState {}

class OnAirTvSeriesSuccess extends TvSeriesState {
  final List<TvSeries> tvSeriesList;

  OnAirTvSeriesSuccess({required this.tvSeriesList});
}

class OnAirTvSeriesError extends TvSeriesState {
  final String message;

  OnAirTvSeriesError({required this.message});
}

//popular
class PopularTvSeriesInitial extends TvSeriesState {}

class PopularTvSeriesLoading extends TvSeriesState {}

class PopularTvSeriesSuccess extends TvSeriesState {
  final List<TvSeries> tvSeriesList;

  PopularTvSeriesSuccess({required this.tvSeriesList});
}

class PopularTvSeriesError extends TvSeriesState {
  final String message;

  const PopularTvSeriesError({required this.message});
}

//top rated
class TopRatedTvSeriesInitial extends TvSeriesState {}

class TopRatedTvSeriesLoading extends TvSeriesState {}

class TopRatedTvSeriesSuccess extends TvSeriesState {
  final List<TvSeries> tvSeriesList;

  TopRatedTvSeriesSuccess({required this.tvSeriesList});
}

class TopRatedTvSeriesError extends TvSeriesState {
  final String message;

  const TopRatedTvSeriesError({required this.message});
}

//recommendation
class RecommendationsTvSeriesInitial extends TvSeriesState {}

class RecommendationsTvSeriesLoading extends TvSeriesState {}

class RecommendationsTvSeriesSuccess extends TvSeriesState {
  final List<TvSeries> tvSeriesList;

  RecommendationsTvSeriesSuccess({required this.tvSeriesList});
}

class RecommendationsTvSeriesError extends TvSeriesState {
  final String message;

  const RecommendationsTvSeriesError({required this.message});
}

//search
class SearchTvSeriesInitial extends TvSeriesState {}

class SearchTvSeriesLoading extends TvSeriesState {}

class SearchTvSeriesSuccess extends TvSeriesState {
  final List<TvSeries> tvSeriesList;

  SearchTvSeriesSuccess({required this.tvSeriesList});
}

class SearchTvSeriesError extends TvSeriesState {
  final String message;

  const SearchTvSeriesError({required this.message});
}

//detail
class TvSeriesDetailInitial extends TvSeriesState {}

class TvSeriesDetailLoading extends TvSeriesState {}

class TvSeriesDetailSuccess extends TvSeriesState {
  final TvSeriesDetail tvSeriesDetail;

  TvSeriesDetailSuccess({required this.tvSeriesDetail});
}

class TvSeriesDetailError extends TvSeriesState {
  final String message;

  const TvSeriesDetailError({required this.message});
}

//watchlist
class TvSeriesWatchlistInitial extends TvSeriesState {}

class TvSeriesWatchlistLoading extends TvSeriesState {}

class TvSeriesWatchlistSuccess extends TvSeriesState {
  final  List<TvSeries> tvSeriesList;

  TvSeriesWatchlistSuccess({required this.tvSeriesList});
}

class TvSeriesWatchlistStatus extends TvSeriesState {
  final bool value;

  const TvSeriesWatchlistStatus({required this.value});


}

class TvSeriesWatchlistMessage extends TvSeriesState {
  final String message;

  const TvSeriesWatchlistMessage({required this.message});
}

class TvSeriesWatchlistError extends TvSeriesState {
  final String message;

  const TvSeriesWatchlistError({required this.message});
}
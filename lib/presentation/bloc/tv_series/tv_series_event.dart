part of 'tv_series_bloc.dart';

abstract class TvSeriesEvent extends Equatable {
  const TvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchOnAirTvSeries extends TvSeriesEvent {}

class FetchPopularTvSeries extends TvSeriesEvent {}

class FetchTopRatedTvSeries extends TvSeriesEvent {}

class FetchRecommendationsTvSeries extends TvSeriesEvent {
  final int id;

  const FetchRecommendationsTvSeries({required this.id});
}

class FetchSearchTvSeries extends TvSeriesEvent {
  final String value;

  const FetchSearchTvSeries({required this.value});

}

class FetchDetailTvSeries extends TvSeriesEvent {
  final int id;

  const FetchDetailTvSeries({required this.id});
}

class FetchWatchlistTvSeries extends TvSeriesEvent {}

class FetchWatchlistTvSeriesStatus extends TvSeriesEvent {
  final int id;

  const FetchWatchlistTvSeriesStatus({required this.id});
}

class AddWatchlistTvSeries extends TvSeriesEvent {
  final TvSeriesDetail tvDetail;

  const AddWatchlistTvSeries(this.tvDetail);
}

class RemoveWatchlistTvSeries extends TvSeriesEvent {
  final TvSeriesDetail tvDetail;

  const RemoveWatchlistTvSeries(this.tvDetail);
}

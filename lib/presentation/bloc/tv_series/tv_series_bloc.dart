import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_series.dart';
import '../../../domain/entities/tv_series_detail.dart';
import '../../../domain/usecases/get_on_air_tv_series.dart';
import '../../../domain/usecases/get_top_rated_tv_series.dart';
import '../../../domain/usecases/get_tv_series_watchlist_status.dart';

part 'tv_series_event.dart';

part 'tv_series_state.dart';

class TvSeriesOnAirBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final GetOnAirTvSeries _getOnAirTvSeries;

  TvSeriesOnAirBloc(this._getOnAirTvSeries) : super(OnAirTvSeriesInitial()) {
    on<FetchOnAirTvSeries>((event, emit) async {
      emit(OnAirTvSeriesLoading());

      final result = await _getOnAirTvSeries.execute();

      result.fold((l) => emit(OnAirTvSeriesError(message: l.message)),
          (r) => emit(OnAirTvSeriesSuccess(tvSeriesList: r)));
    });
  }
}

class TvSeriesPopularBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final GetPopularTvSeries _getPopularTvSeries;

  TvSeriesPopularBloc(this._getPopularTvSeries)
      : super(PopularTvSeriesInitial()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(PopularTvSeriesInitial());

      final result = await _getPopularTvSeries.execute();

      result.fold((l) => emit(PopularTvSeriesError(message: l.message)),
          (r) => emit(PopularTvSeriesSuccess(tvSeriesList: r)));
    });
  }
}

class TvSeriesTopRatedBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TvSeriesTopRatedBloc(this._getTopRatedTvSeries)
      : super(TopRatedTvSeriesInitial()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TopRatedTvSeriesLoading());

      final result = await _getTopRatedTvSeries.execute();

      result.fold((l) => emit(TopRatedTvSeriesError(message: l.message)),
          (r) => emit(TopRatedTvSeriesSuccess(tvSeriesList: r)));
    });
  }
}

class TvSeriesDetailBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final GetTvSeriesDetail _getTvSeriesDetail;

  TvSeriesDetailBloc(this._getTvSeriesDetail)
      : super(TvSeriesDetailInitial()) {
    on<FetchDetailTvSeries>((event, emit) async {
      emit(TvSeriesWatchlistLoading());

      final result = await _getTvSeriesDetail.execute(event.id);

      result.fold((l) => emit(TvSeriesDetailError(message: l.message)),
              (r) => emit(TvSeriesDetailSuccess(tvSeriesDetail: r)));
    });
  }
}


class TvSeriesRecommendationsBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;

  TvSeriesRecommendationsBloc(this._getTvSeriesRecommendations)
      : super(RecommendationsTvSeriesInitial()) {
    on<FetchRecommendationsTvSeries>((event, emit) async {
      emit(RecommendationsTvSeriesLoading());

      final result = await _getTvSeriesRecommendations.execute(event.id);

      result.fold((l) => emit(RecommendationsTvSeriesError(message: l.message)),
          (r) => emit(RecommendationsTvSeriesSuccess(tvSeriesList: r)));
    });
  }
}

class TvSeriesSearchBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final SearchTvSeries _searchTvSeries;

  TvSeriesSearchBloc(this._searchTvSeries)
      : super(SearchTvSeriesInitial()) {
    on<FetchSearchTvSeries>((event, emit) async {
      emit(SearchTvSeriesLoading());

      final result = await _searchTvSeries.execute(event.value);

      result.fold((l) => emit(SearchTvSeriesError(message: l.message)),
              (r) => emit(SearchTvSeriesSuccess(tvSeriesList: r)));
    });
  }
}

class TvSeriesWatchlistBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final GetTvSeriesWatchlist _getTvSeriesWatchlist;
  final GetTvSeriesWatchlistStatus _getTvSeriesWatchlistStatus;
  final SaveTvSeriesWatchlist _saveTVSeriesWatchlist;
  final RemoveTvSeriesWatchlist _removeTVSeriesWatchlist;

  TvSeriesWatchlistBloc(
      this._getTvSeriesWatchlist,
      this._getTvSeriesWatchlistStatus,
      this._saveTVSeriesWatchlist,
      this._removeTVSeriesWatchlist)
      : super(TvSeriesWatchlistInitial()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(TvSeriesWatchlistLoading());

      final result = await _getTvSeriesWatchlist.execute();

      result.fold((l) => emit(TvSeriesWatchlistError(message: l.message)),
          (r) => emit(TvSeriesWatchlistSuccess(tvSeriesList: r)));
    });

    on<FetchWatchlistTvSeriesStatus>((event, emit) async {
      emit(TvSeriesWatchlistLoading());
      final result = await _getTvSeriesWatchlistStatus.execute(event.id);
      emit(TvSeriesWatchlistStatus(value: result));
    });

    on<AddWatchlistTvSeries>((event, emit) async {
      final result = await _saveTVSeriesWatchlist.execute(event.tvDetail);

      result.fold((l) => emit(TvSeriesWatchlistError(message: l.message)),
          (r) => emit(TvSeriesWatchlistMessage(message: r)));

    });

    on<RemoveWatchlistTvSeries>((event, emit) async {
      final result = await _removeTVSeriesWatchlist.execute(event.tvDetail);

      result.fold((l) => emit(TvSeriesWatchlistError(message: l.message)),
          (r) => emit(TvSeriesWatchlistMessage(message: r)));
    });
  }
}

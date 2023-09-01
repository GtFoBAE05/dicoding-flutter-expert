import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const tvSeriesWatchlistAddSuccessMessage =
      'Added this tv series to Watchlist';
  static const tvSeriesWatchlistRemoveSuccessMessage =
      'Removed tv series from Watchlist';

  final GetTvSeriesDetail geTvSeriesDetail;
  final GetTvSeriesRecommendations geTvSeriesRecommendations;
  final GetTvSeriesWatchlistStatus geTvSeriesWatchListStatus;
  final SaveTvSeriesWatchlist saveSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeSeriesWatchlist;

  TvSeriesDetailNotifier(
      {required this.geTvSeriesDetail,
      required this.geTvSeriesRecommendations,
      required this.geTvSeriesWatchListStatus,
      required this.saveSeriesWatchlist,
      required this.removeSeriesWatchlist});

  late TvSeriesDetail _tvSeriesDetail;
  TvSeriesDetail get tvSeriesDetail => _tvSeriesDetail;

  RequestState _tvSeriesState = RequestState.Empty;

  RequestState get tvSeriesState => _tvSeriesState;

  List<TvSeries> _tvSeriesRecommendations = [];

  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _tvSeriesRecommendationState = RequestState.Empty;

  RequestState get tvSeriesRecommendationState => _tvSeriesRecommendationState;

  String _message = '';

  String get message => _message;

  bool _isTvSeriesAddedtoWatchlist = false;

  bool get isTvSeriesAddedToWatchlist => _isTvSeriesAddedtoWatchlist;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await geTvSeriesDetail.execute(id);
    final recommendationResult = await geTvSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesDetailResult) {
        _tvSeriesRecommendationState = RequestState.Loading;
        _tvSeriesDetail = tvSeriesDetailResult;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _tvSeriesRecommendationState = RequestState.Error;
            _message = failure.message;
          },
          (recommendationResult) {
            _tvSeriesRecommendationState = RequestState.Loaded;
            _tvSeriesRecommendations = recommendationResult;
          },
        );
        _tvSeriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  Future<void> addTvSeriesWatchlist(TvSeriesDetail tvSeriesDetail) async {
    final result = await saveSeriesWatchlist.execute(tvSeriesDetail);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadTvSeriesWatchlistStatus(tvSeriesDetail.id);
  }

  Future<void> removeTvSeriesFromWatchlist(TvSeriesDetail tvSeriesDetail) async {
    final result = await removeSeriesWatchlist.execute(tvSeriesDetail);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadTvSeriesWatchlistStatus(tvSeriesDetail.id);
  }

  Future<void> loadTvSeriesWatchlistStatus(int id) async {
    final result = await geTvSeriesWatchListStatus.execute(id);
    _isTvSeriesAddedtoWatchlist = result;
    notifyListeners();
  }
}

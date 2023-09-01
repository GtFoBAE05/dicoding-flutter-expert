import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _tvSeriesWatchlistState = RequestState.Empty;
  RequestState get tvSeriesWatchlistState => _tvSeriesWatchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvSeriesNotifier({required this.getTvSeriesWatchlist});

  final GetTvSeriesWatchlist getTvSeriesWatchlist;

  Future<void> fetchTvSeriesWatchlist() async {
    _tvSeriesWatchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeriesWatchlist.execute();
    result.fold(
          (failure) {
        _tvSeriesWatchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (result) {
        _tvSeriesWatchlistState = RequestState.Loaded;
        _watchlistTvSeries = result;
        notifyListeners();
      },
    );
  }
}
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';

class TvSeriesNotifier extends ChangeNotifier {
  TvSeriesNotifier(
      {required this.getOnAirTvSeries,
      required this.getPopularTvSeries,
      required this.getTopRatedTvSeries});

  var _onAirTvSeries = <TvSeries>[];

  List<TvSeries> get onAirTvSeries => _onAirTvSeries;

  RequestState _onAirTvSeriesState = RequestState.Empty;

  RequestState get onAirTvSeriesState => _onAirTvSeriesState;

  var _popularTvSeries = <TvSeries>[];

  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.Empty;

  RequestState get popularTvSeriesState => _popularTvSeriesState;

  var _topRatedTvSeries = <TvSeries>[];

  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedTvSeriesState = RequestState.Empty;

  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  String _message = '';

  String get message => _message;

  final GetOnAirTvSeries getOnAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> fetchOnAirTvSeries() async {
    _onAirTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvSeries.execute();
    result.fold(
      (failure) {
        _onAirTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (result) {
        _onAirTvSeriesState = RequestState.Loaded;
        _onAirTvSeries = result;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularMovies() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (result) {
        _popularTvSeriesState = RequestState.Loaded;
        _popularTvSeries = result;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedMovies() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (result) {
        _topRatedTvSeriesState = RequestState.Loaded;
        _topRatedTvSeries = result;
        notifyListeners();
      },
    );
  }
}

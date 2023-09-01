import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';

class OnAirTvSeriesNotifier extends ChangeNotifier {
  final GetOnAirTvSeries getOnAirTvSeries;
  OnAirTvSeriesNotifier(this.getOnAirTvSeries);


  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TvSeries> _tvSeries = [];

  List<TvSeries> get tvSeries => _tvSeries;

  String _message = '';

  String get message => _message;

  Future<void> fetchOnAirTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvSeries.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (result) {
        _tvSeries = result;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
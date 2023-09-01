import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesOnAirBloc tvSeriesOnAirBloc;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;

  setUp(() {
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    tvSeriesOnAirBloc = TvSeriesOnAirBloc(mockGetOnAirTvSeries);
  });

  group("On air tv series Test", () {
    blocTest<TvSeriesOnAirBloc, TvSeriesState>(
      'return success when fetch success',
      build: () {
        when(mockGetOnAirTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(testTvSeriesList));
        return tvSeriesOnAirBloc;
      },
      act: (bloc) {
        bloc.add(FetchOnAirTvSeries());
      },
      expect: () => <TvSeriesState>[
        OnAirTvSeriesLoading(),
        OnAirTvSeriesSuccess(tvSeriesList: testTvSeriesList)
      ],
    );

    blocTest<TvSeriesOnAirBloc, TvSeriesState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetOnAirTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return tvSeriesOnAirBloc;
      },
      act: (bloc) {
        bloc.add(FetchOnAirTvSeries());
      },
      expect: () => <TvSeriesState>[
        OnAirTvSeriesLoading(),
        OnAirTvSeriesError(message: "404")
      ],
    );
  });
}
import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';


void main() {
  late TvSeriesPopularBloc tvSeriesPopularBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    tvSeriesPopularBloc = TvSeriesPopularBloc(mockGetPopularTvSeries);
  });

  group("Popular Movie Test", () {
    blocTest<TvSeriesPopularBloc, TvSeriesState>(
      'return success when fetch success',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(testTvSeriesList));
        return tvSeriesPopularBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
      },
      expect: () => <TvSeriesState>[
        PopularTvSeriesLoading(),
        PopularTvSeriesSuccess(tvSeriesList: testTvSeriesList)
      ],
    );

    blocTest<TvSeriesPopularBloc, TvSeriesState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return tvSeriesPopularBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularTvSeries());
      },
      expect: () => <TvSeriesState>[
        PopularTvSeriesLoading(),
        PopularTvSeriesError(message: "404")
      ],
    );
  });
}
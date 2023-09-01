import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesTopRatedBloc topRatedBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedBloc = TvSeriesTopRatedBloc(mockGetTopRatedTvSeries);
  });

  group("Top Rated tv series Test", () {
    blocTest<TvSeriesTopRatedBloc, TvSeriesState>(
      'return success when fetch success',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(testTvSeriesList));
        return topRatedBloc;
      },
      act: (bloc) {
        bloc.add(FetchTopRatedTvSeries());
      },
      expect: () => <TvSeriesState>[
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesSuccess(tvSeriesList: testTvSeriesList)
      ],
    );

    blocTest<TvSeriesTopRatedBloc, TvSeriesState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return topRatedBloc;
      },
      act: (bloc) {
        bloc.add(FetchTopRatedTvSeries());
      },
      expect: () => <TvSeriesState>[
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesError(message: "404")
      ],
    );
  });
}

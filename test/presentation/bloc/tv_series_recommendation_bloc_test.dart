import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRecommendationsBloc tvSeriesRecommendationsBloc;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesRecommendationsBloc = TvSeriesRecommendationsBloc(mockGetTvSeriesRecommendations);
  });

  final tId = 1;

  group("Recommendation tv series Test", () {
    blocTest<TvSeriesRecommendationsBloc, TvSeriesState>(
      'return success when fetch success',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Right(testTvSeriesList));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) {
        bloc.add(FetchRecommendationsTvSeries(id: tId));
      },
      expect: () => <TvSeriesState>[
        RecommendationsTvSeriesLoading(),
        RecommendationsTvSeriesSuccess( tvSeriesList: testTvSeriesList)
      ],
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) {
        bloc.add(FetchRecommendationsTvSeries(id: tId));
      },
      expect: () => <TvSeriesState>[
        RecommendationsTvSeriesLoading(),
        RecommendationsTvSeriesError(message: "404")
      ],
    );
  });
}
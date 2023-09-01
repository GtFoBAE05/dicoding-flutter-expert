import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRecommendationBloc movieRecommendationBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationBloc = MovieRecommendationBloc(mockGetMovieRecommendations);
  });
  
  final tId = 1;

  group("Recommendation Movie Test", () {
    blocTest<MovieRecommendationBloc, MovieState>(
      'return success when fetch success',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieRecommendationBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieRecommendation(id: tId));
      },
      expect: () => <MovieState>[
        RecommendationMovieLoading(),
        RecommendationMovieSuccess(movies: testMovieList)
      ],
    );

    blocTest<MovieRecommendationBloc, MovieState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return movieRecommendationBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieRecommendation(id: tId));
      },
      expect: () => <MovieState>[
        RecommendationMovieLoading(),
        RecommendationMovieError(message: "404")
      ],
    );
  });
}
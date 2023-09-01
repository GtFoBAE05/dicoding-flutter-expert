import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MoviePopularBloc moviePopularBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    moviePopularBloc = MoviePopularBloc(mockGetPopularMovies);
  });

  group("Popular Movie Test", () {
    blocTest<MoviePopularBloc, MovieState>(
      'return success when fetch success',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return moviePopularBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularMovie());
      },
      expect: () => <MovieState>[
        PopularMovieLoading(),
        PopularMovieSuccess(movies: testMovieList)
      ],
    );

    blocTest<MoviePopularBloc, MovieState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return moviePopularBloc;
      },
      act: (bloc) {
        bloc.add(FetchPopularMovie());
      },
      expect: () => <MovieState>[
        PopularMovieLoading(),
        PopularMovieError(message: "404")
      ],
    );
  });
}
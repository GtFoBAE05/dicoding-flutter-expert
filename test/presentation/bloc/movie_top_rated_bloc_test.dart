import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieTopRatedBloc movieTopRatedBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieTopRatedBloc = MovieTopRatedBloc(mockGetTopRatedMovies);
  });

  group("Top Rated Movie Test", () {
    blocTest<MovieTopRatedBloc, MovieState>(
      'return success when fetch success',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieTopRatedBloc;
      },
      act: (bloc) {
        bloc.add(FetchTopRatedMovie());
      },
      expect: () => <MovieState>[
        TopRatedMovieLoading(),
        TopRatedMovieSuccess(movies: testMovieList)
      ],
    );

    blocTest<MovieTopRatedBloc, MovieState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return movieTopRatedBloc;
      },
      act: (bloc) {
        bloc.add(FetchTopRatedMovie());
      },
      expect: () => <MovieState>[
        TopRatedMovieLoading(),
        TopRatedMovieError(message: "404")
      ],
    );
  });
}

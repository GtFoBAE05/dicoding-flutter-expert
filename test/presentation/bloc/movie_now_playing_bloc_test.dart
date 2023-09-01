import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieNowPlayingBloc movieNowPlayingBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    movieNowPlayingBloc = MovieNowPlayingBloc(mockGetNowPlayingMovies);
  });

  group("Now Playing Movie Test", () {
    blocTest<MovieNowPlayingBloc, MovieState>(
      'return success when fetch success',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieNowPlayingBloc;
      },
      act: (bloc) {
        bloc.add(FetchNowPlayingMovie());
      },
      expect: () => <MovieState>[
        NowPlayingMovieLoading(),
        NowPlayingMovieSuccess(movies: testMovieList)
      ],
    );

    blocTest<MovieNowPlayingBloc, MovieState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("404")));
        return movieNowPlayingBloc;
      },
      act: (bloc) {
        bloc.add(FetchNowPlayingMovie());
      },
      expect: () => <MovieState>[
        NowPlayingMovieLoading(),
        NowPlayingMovieError(message: "404")
      ],
    );
  });
}

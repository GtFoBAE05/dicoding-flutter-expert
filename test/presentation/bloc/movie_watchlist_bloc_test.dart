import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(mockGetWatchlistMovies,
        mockGetWatchListStatus, mockSaveWatchlist, mockRemoveWatchlist);
  });

  final tId = 1;
  final movieList = <Movie>[testMovie];

  group("Watchlist Movie Test", () {
    blocTest<MovieWatchlistBloc, MovieState>(
      'get movie watchlist return success',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((realInvocation) async => Right(movieList));
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieWatchlist());
      },
      expect: () => <MovieState>[
        WatchlistMovieLoading(),
        WatchlistMovieSuccess(movies: movieList)
      ],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'get movie watchlist return err',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((realInvocation) async => Left(DatabaseFailure("ERR")));
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieWatchlist());
      },
      expect: () => <MovieState>[
        WatchlistMovieLoading(),
        WatchlistMovieError(message: "ERR")
      ],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'get movie watchlist status true',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((realInvocation) async => true);
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieWatchlistStatus(id: tId));
      },
      expect: () => <MovieState>[
        WatchlistMovieLoading(),
        WatchlistMovieStatus(value: true)
      ],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'get movie watchlist status false',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((realInvocation) async => false);
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieWatchlistStatus(id: tId));
      },
      expect: () => <MovieState>[
        WatchlistMovieLoading(),
        WatchlistMovieStatus(value: false)
      ],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'save movie watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((realInvocation) async => Right("add to watchlist"));
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(AddMovieWatchlist(movieDetail: testMovieDetail));
      },
      expect: () =>
          <MovieState>[WatchlistMovieMessage(message: "add to watchlist")],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'save movie watchlist err',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (realInvocation) async => Left(DatabaseFailure("failed")));
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(AddMovieWatchlist(movieDetail: testMovieDetail));
      },
      expect: () => <MovieState>[WatchlistMovieError(message: "failed")],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'remove movie watchlist success',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (realInvocation) async => Right("removed from watchlist"));
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(RemoveMovieWatchlist(movieDetail: testMovieDetail));
      },
      expect: () => <MovieState>[
        WatchlistMovieMessage(message: "removed from watchlist")
      ],
    );

    blocTest<MovieWatchlistBloc, MovieState>(
      'remove movie watchlist err',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (realInvocation) async => Left(DatabaseFailure("failed")));
        return movieWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(RemoveMovieWatchlist(movieDetail: testMovieDetail));
      },
      expect: () => <MovieState>[WatchlistMovieError(message: "failed")],
    );
  });
}

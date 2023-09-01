import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesWatchlistBloc tvSeriesWatchlistBloc;
  late MockGetTvSeriesWatchlist mockGetTvSeriesWatchlist;
  late MockGetTvSeriesWatchlistStatus mockGetTvSeriesWatchlistStatus;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;

  setUp(() {
    mockGetTvSeriesWatchlist = MockGetTvSeriesWatchlist();
    mockGetTvSeriesWatchlistStatus = MockGetTvSeriesWatchlistStatus();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    tvSeriesWatchlistBloc = TvSeriesWatchlistBloc(mockGetTvSeriesWatchlist,
        mockGetTvSeriesWatchlistStatus, mockSaveTvSeriesWatchlist, mockRemoveTvSeriesWatchlist);
  });

  final tId = 1;

  group("Watchlist tv series Test", () {
    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'get tv series watchlist return success',
      build: () {
        when(mockGetTvSeriesWatchlist.execute())
            .thenAnswer((realInvocation) async => Right(testTvSeriesList));
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchWatchlistTvSeries());
      },
      expect: () => <TvSeriesState>[
        TvSeriesWatchlistLoading(),
        TvSeriesWatchlistSuccess(tvSeriesList: testTvSeriesList)
      ],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'get tv series watchlist return err',
      build: () {
        when(mockGetTvSeriesWatchlist.execute())
            .thenAnswer((realInvocation) async => Left(DatabaseFailure("ERR")));
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchWatchlistTvSeries());
      },
      expect: () => <TvSeriesState>[
        TvSeriesWatchlistLoading(),
        TvSeriesWatchlistError(message: "ERR")
      ],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'get tv series watchlist status true',
      build: () {
        when(mockGetTvSeriesWatchlistStatus.execute(tId))
            .thenAnswer((realInvocation) async => true);
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchWatchlistTvSeriesStatus(id: tId));
      },
      expect: () => <TvSeriesState>[
        TvSeriesWatchlistLoading(),
        TvSeriesWatchlistStatus(value: true)
      ],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'get tv series watchlist status false',
      build: () {
        when(mockGetTvSeriesWatchlistStatus.execute(tId))
            .thenAnswer((realInvocation) async => false);
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(FetchWatchlistTvSeriesStatus(id: tId));
      },
      expect: () => <TvSeriesState>[
        TvSeriesWatchlistLoading(),
        TvSeriesWatchlistStatus(value: false)
      ],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'save tv series watchlist success',
      build: () {
        when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((realInvocation) async => Right("add to watchlist"));
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(AddWatchlistTvSeries(testTvSeriesDetail));
      },
      expect: () =>
      <TvSeriesState>[TvSeriesWatchlistMessage(message: "add to watchlist")],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'save tv series watchlist err',
      build: () {
        when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)).thenAnswer(
                (realInvocation) async => Left(DatabaseFailure("failed")));
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(AddWatchlistTvSeries(testTvSeriesDetail));
      },
      expect: () => <TvSeriesState>[TvSeriesWatchlistError(message: "failed")],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'remove tv series watchlist success',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail)).thenAnswer(
                (realInvocation) async => Right("removed from watchlist"));
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(RemoveWatchlistTvSeries(testTvSeriesDetail));
      },
      expect: () => <TvSeriesState>[
        TvSeriesWatchlistMessage(message: "removed from watchlist")
      ],
    );

    blocTest<TvSeriesWatchlistBloc, TvSeriesState>(
      'remove tv series watchlist err',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail)).thenAnswer(
                (realInvocation) async => Left(DatabaseFailure("failed")));
        return tvSeriesWatchlistBloc;
      },
      act: (bloc) {
        bloc.add(RemoveWatchlistTvSeries(testTvSeriesDetail));
      },
      expect: () => <TvSeriesState>[TvSeriesWatchlistError(message: "failed")],
    );
  });
}
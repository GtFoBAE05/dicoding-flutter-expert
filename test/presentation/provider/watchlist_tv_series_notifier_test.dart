import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeriesWatchlist])
void main() {
  late WatchlistTvSeriesNotifier provider;
  late MockGetTvSeriesWatchlist mockGetTvSeriesWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesWatchlist = MockGetTvSeriesWatchlist();
    provider = WatchlistTvSeriesNotifier(
      getTvSeriesWatchlist: mockGetTvSeriesWatchlist,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  test('should change tv series data when data is gotten successfully', () async {
    // arrange
    when(mockGetTvSeriesWatchlist.execute())
        .thenAnswer((_) async => Right([testTvSeriesWatchlist]));
    // act
    await provider.fetchTvSeriesWatchlist();
    // assert
    expect(provider.tvSeriesWatchlistState, RequestState.Loaded);
    expect(provider.watchlistTvSeries, [testTvSeriesWatchlist]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTvSeriesWatchlist.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchTvSeriesWatchlist();
    // assert
    expect(provider.tvSeriesWatchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });

}
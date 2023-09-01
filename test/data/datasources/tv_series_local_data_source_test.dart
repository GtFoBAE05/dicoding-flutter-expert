import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl tvSeriesLocalDataSourceImpl;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    tvSeriesLocalDataSourceImpl =
        TvSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save tv series watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await tvSeriesLocalDataSourceImpl
          .insertTvSeriesWatchlist(testTvSeriesTable);
      // assert
      expect(result, 'Added to Tv Series Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = tvSeriesLocalDataSourceImpl
          .insertTvSeriesWatchlist(testTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove tv series watchlist', () {
    test('should return success message when remove from database is success',
            () async {
          // arrange
          when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await tvSeriesLocalDataSourceImpl.removeTvSeriesWatchlist(testTvSeriesTable);
          // assert
          expect(result, 'Removed Tv Series from Watchlist');
        });

    test('should throw DatabaseException when remove from database is failed',
            () async {
          // arrange
          when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
              .thenThrow(Exception());
          // act
          final call = tvSeriesLocalDataSourceImpl.removeTvSeriesWatchlist(testTvSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('Get tv series Detail By Id', () {
    final tId = 1;
    test('should return Tv Series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesWatchlistDetailById(tId))
          .thenAnswer((_) async => testTvSeriesMap);
      // act
      final result = await tvSeriesLocalDataSourceImpl.getTvSeriesById(tId);
      // assert
      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesWatchlistDetailById(tId)).thenAnswer((_) async => null);
      // act
      final result = await tvSeriesLocalDataSourceImpl.getTvSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesWatchlist())
          .thenAnswer((_) async => [testTvSeriesMap]);
      // act
      final result = await tvSeriesLocalDataSourceImpl.getTvSeriesWatchlist();
      // assert
      expect(result, [testTvSeriesTable]);
    });
  });
  
}

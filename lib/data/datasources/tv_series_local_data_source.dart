import 'package:ditonton/data/models/tv_series_table.dart';

import '../../common/exception.dart';
import 'db/database_helper.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertTvSeriesWatchlist(TvSeriesTable tvSeries);

  Future<String> removeTvSeriesWatchlist(TvSeriesTable tvSeries);

  Future<TvSeriesTable?> getTvSeriesById(int id);

  Future<List<TvSeriesTable>> getTvSeriesWatchlist();
}

class TvSeriesLocalDataSourceImpl extends TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesWatchlistDetailById(id);
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getTvSeriesWatchlist() async {
    final result = await databaseHelper.getTvSeriesWatchlist();
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertTvSeriesWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertTvSeriesWatchlist(tvSeries);
      return 'Added to Tv Series Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTvSeriesWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeTvSeriesWatchlist(tvSeries);
      return 'Removed Tv Series from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}

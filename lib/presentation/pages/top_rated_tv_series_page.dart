import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/top-rated-tv-series";

  const TopRatedTvSeriesPage();

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<TopRatedTvSeriesNotifier>().fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvSeriesNotifier>(
          builder: (context, value, child) {
            if (value.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvSeriesCard(value.tvSeries[index]);
                },
                itemCount: value.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(value.message),
              );
            }
          },
        ),
      ),
    );
  }
}

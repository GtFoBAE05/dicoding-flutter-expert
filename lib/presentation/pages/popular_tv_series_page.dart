import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/popular-tv-series";
  const PopularTvSeriesPage();

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<PopularTvSeriesNotifier>().fetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Tv Series"),
      ),
      body: Consumer<PopularTvSeriesNotifier>(
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
    );
  }
}

import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../bloc/tv_series/tv_series_bloc.dart';

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
    Future.microtask(() => context.read<TvSeriesPopularBloc>().add(FetchPopularTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Tv Series"),
      ),
      body: BlocBuilder<TvSeriesPopularBloc, TvSeriesState>(
        builder: (context, state) {
          if (state is PopularTvSeriesInitial || state is PopularTvSeriesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularTvSeriesSuccess) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return TvSeriesCard(state.tvSeriesList[index]);
              },
              itemCount: state.tvSeriesList.length,
            );
          } else if(state is PopularTvSeriesError){
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          }else{
            return Center(
              child: Text("ERR"),
            );
          }
        },
      )
    );
  }
}

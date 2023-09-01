import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../bloc/tv_series/tv_series_bloc.dart';

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
    Future.microtask(() => context.read<TvSeriesTopRatedBloc>().add(FetchTopRatedTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: BlocBuilder<TvSeriesTopRatedBloc, TvSeriesState>(
        builder: (context, state) {
          if (state is TopRatedTvSeriesInitial || state is TopRatedTvSeriesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedTvSeriesSuccess) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return TvSeriesCard(state.tvSeriesList[index]);
              },
              itemCount: state.tvSeriesList.length,
            );
          } else if(state is TopRatedTvSeriesError){
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

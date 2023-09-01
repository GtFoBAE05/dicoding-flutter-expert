import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../../common/utils.dart';

class WatchlistTvSeriesPage extends StatefulWidget {

  static const ROUTE_NAME = "/watchlist-tv-series";

  const WatchlistTvSeriesPage();

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage> with RouteAware {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<TvSeriesWatchlistBloc>().add(FetchWatchlistTvSeries()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<TvSeriesWatchlistBloc>().add(FetchWatchlistTvSeries());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesWatchlistBloc, TvSeriesState>(
          builder: (context, state) {
            if (state is TvSeriesWatchlistLoading ||state is TvSeriesWatchlistInitial  ) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSeriesWatchlistSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvSeriesCard(state.tvSeriesList[index]);
                },
                itemCount:state.tvSeriesList.length,
              );
            }else if(state is TvSeriesWatchlistError){
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
            else {
              return Center(
                child: Text("ERR"),
              );
            }
          },
        ),
      ),
    );
  }
}

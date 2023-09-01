import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/on_air_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series_search_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../bloc/tv_series/tv_series_bloc.dart';
import '../provider/tv_series_list_notifier.dart';

class TvSeriesHomePage extends StatefulWidget {
  static const ROUTE_NAME = "/tv-series";

  const TvSeriesHomePage();

  @override
  State<TvSeriesHomePage> createState() => _TvSeriesHomePageState();
}

class _TvSeriesHomePageState extends State<TvSeriesHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesOnAirBloc>().add(FetchOnAirTvSeries());
      context.read<TvSeriesPopularBloc>().add(FetchPopularTvSeries());
      context.read<TvSeriesTopRatedBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TvSeriesSearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeading(
              title: "On Air Tv Series",
              onTap: () => Navigator.of(context).pushNamed(
                OnAirTvSeries.ROUTE_NAME,
              ),
            ),
            BlocBuilder<TvSeriesOnAirBloc, TvSeriesState>(
              builder: (context, state) {
                if (state is OnAirTvSeriesInitial || state is OnAirTvSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnAirTvSeriesSuccess) {
                  return TvSeriesList(state.tvSeriesList);
                } else{
                  return Center(
                    child: Text("ERR"),
                  );
                }
              },
            ),
            SubHeading(
              title: "Popular Tv Series",
              onTap: () => Navigator.of(context).pushNamed(
                PopularTvSeriesPage.ROUTE_NAME,
              ),
            ),
            BlocBuilder<TvSeriesPopularBloc, TvSeriesState>(
              builder: (context, state) {
                if (state is PopularTvSeriesInitial || state is PopularTvSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvSeriesSuccess) {
                  return TvSeriesList(state.tvSeriesList);
                } else{
                  return Center(
                    child: Text("ERR"),
                  );
                }
              },
            ),
            SubHeading(
              title: "Top Rated Tv Series",
              onTap: () => Navigator.of(context).pushNamed(
                TopRatedTvSeriesPage.ROUTE_NAME,
              ),
            ),
            BlocBuilder<TvSeriesTopRatedBloc, TvSeriesState>(
              builder: (context, state) {
                if (state is TopRatedTvSeriesInitial || state is TopRatedTvSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvSeriesSuccess) {
                  return TvSeriesList(state.tvSeriesList);
                } else{
                  return Center(
                    child: Text("ERR"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeriesList;

  TvSeriesList(this.tvSeriesList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSerie = tvSeriesList[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tvSerie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSerie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeriesList.length,
      ),
    );
  }
}

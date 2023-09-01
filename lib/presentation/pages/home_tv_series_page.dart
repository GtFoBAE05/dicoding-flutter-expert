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
import 'package:provider/provider.dart';

import '../../common/constants.dart';
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
    Future.microtask(() => context.read<TvSeriesNotifier>()
      ..fetchOnAirTvSeries()
      ..fetchPopularMovies()
      ..fetchTopRatedMovies());
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
            Consumer<TvSeriesNotifier>(
              builder: (context, value, child) {
                if (value.onAirTvSeriesState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (value.onAirTvSeriesState == RequestState.Loaded) {
                  return TvSeriesList(value.onAirTvSeries);
                } else {
                  return Text('Failed');
                }
              },
            ),
            SubHeading(
              title: "Popular Tv Series",
              onTap: () => Navigator.of(context).pushNamed(
                PopularTvSeriesPage.ROUTE_NAME,
              ),
            ),
            Consumer<TvSeriesNotifier>(
              builder: (context, value, child) {
                if (value.popularTvSeriesState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (value.popularTvSeriesState == RequestState.Loaded) {
                  return TvSeriesList(value.popularTvSeries);
                } else {
                  return Text('Failed');
                }
              },
            ),
            SubHeading(
              title: "Top Rated Tv Series",
              onTap: () => Navigator.of(context).pushNamed(
                TopRatedTvSeriesPage.ROUTE_NAME,
              ),
            ),
            Consumer<TvSeriesNotifier>(
              builder: (context, value, child) {
                if (value.topRatedTvSeriesState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (value.topRatedTvSeriesState == RequestState.Loaded) {
                  return TvSeriesList(value.topRatedTvSeries);
                } else {
                  return Text('Failed');
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

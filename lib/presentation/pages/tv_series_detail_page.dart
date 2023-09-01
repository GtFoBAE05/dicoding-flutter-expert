import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/genre.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = "/tv-series-detail";
  final int id;

  const TvSeriesDetailPage({required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailState();
}

class _TvSeriesDetailState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context
          .read<TvSeriesDetailBloc>()
          .add(FetchDetailTvSeries(id: widget.id));
      context
          .read<TvSeriesRecommendationsBloc>()
          .add(FetchRecommendationsTvSeries(id: widget.id));
      context
          .read<TvSeriesWatchlistBloc>()
          .add(FetchWatchlistTvSeriesStatus(id: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTvSeriesAddedToWatchlist =
        context.select<TvSeriesWatchlistBloc, bool>((bloc) {
      if (bloc.state is TvSeriesWatchlistStatus) {
        return (bloc.state as TvSeriesWatchlistStatus).value;
      }
      if (bloc.state is TvSeriesWatchlistMessage) {
        return (bloc.state as TvSeriesWatchlistMessage).message ==
            'Added to watchlist';
      }
      return false;
    });

    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesState>(
        builder: (context, state) {
          if (state is TvSeriesDetailInitial ||
              state is TvSeriesDetailLoading ||
              state is TvSeriesWatchlistLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvSeriesDetailSuccess) {
            return SafeArea(
              child: TvSeriesDetailContent(
                state.tvSeriesDetail,
                isTvSeriesAddedToWatchlist,
              ),
            );
          } else if (state is TvSeriesDetailError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text("ERR"),
            );
          }
        },
      ),
    );
  }
}

class TvSeriesDetailContent extends StatefulWidget {
  final TvSeriesDetail tvSeries;

  // final List<TvSeries> tvSeriesRecommendations;
  final bool isTvSeriesAddedWatchlist;

  TvSeriesDetailContent(
      this.tvSeries,
      // required this.tvSeriesRecommendations,
      this.isTvSeriesAddedWatchlist);

  @override
  State<TvSeriesDetailContent> createState() => _TvSeriesDetailContentState();
}

class _TvSeriesDetailContentState extends State<TvSeriesDetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<TvSeriesWatchlistBloc, TvSeriesState>(
      listener: (context, state) {
        if (state is TvSeriesWatchlistMessage) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.message),
                );
              });
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://image.tmdb.org/t/p/w500${widget.tvSeries.posterPath}',
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tvSeries.name,
                                style: kHeading5,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!widget.isTvSeriesAddedWatchlist) {
                                    context.read<TvSeriesWatchlistBloc>().add(
                                        AddWatchlistTvSeries(widget.tvSeries));
                                    context.read<TvSeriesWatchlistBloc>().add(
                                        FetchWatchlistTvSeriesStatus(
                                            id: widget.tvSeries.id));
                                  } else {
                                    context.read<TvSeriesWatchlistBloc>().add(
                                        RemoveWatchlistTvSeries(
                                            widget.tvSeries));
                                    context.read<TvSeriesWatchlistBloc>().add(
                                        FetchWatchlistTvSeriesStatus(
                                            id: widget.tvSeries.id));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.isTvSeriesAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Text(
                                _showGenres(widget.tvSeries.genres),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.tvSeries.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.tvSeries.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.tvSeries.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              BlocBuilder<TvSeriesRecommendationsBloc,
                                  TvSeriesState>(
                                builder: (context, state) {
                                  if (state is RecommendationsTvSeriesInitial ||
                                      state is RecommendationsTvSeriesLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state
                                      is RecommendationsTvSeriesError) {
                                    return Text(state.message);
                                  } else if (state
                                      is RecommendationsTvSeriesSuccess) {
                                    return Container(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  TvSeriesDetailPage.ROUTE_NAME,
                                                  arguments: state
                                                      .tvSeriesList[index].id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w500${state.tvSeriesList[index].posterPath}',
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: state.tvSeriesList.length,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              // initialChildSize: 0.5,
              minChildSize: 0.25,
              // maxChildSize: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

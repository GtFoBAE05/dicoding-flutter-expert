import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../bloc/movies/movie_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;

  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchMovieDetail(id: widget.id));
      context
          .read<MovieRecommendationBloc>()
          .add(FetchMovieRecommendation(id: widget.id));
      context
          .read<MovieWatchlistBloc>()
          .add(FetchMovieWatchlistStatus(id: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMovieAddedToWatchlist =
        context.select<MovieWatchlistBloc, bool>((bloc) {
      if (bloc.state is WatchlistMovieStatus) {
        return (bloc.state as WatchlistMovieStatus).value;
      }
      if (bloc.state is WatchlistMovieMessage) {
        return (bloc.state as WatchlistMovieMessage).message ==
            'Added to watchlist';
      }
      return false;
    });

    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieState>(
        builder: (context, state) {
          if (state is DetailMovieInitial ||
              state is DetailMovieLoading ||
              state is WatchlistMovieLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailMovieSuccess) {
            return SafeArea(
              child: DetailContent(state.movieDetail, isMovieAddedToWatchlist),
            );
          } else if (state is DetailMovieError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Text("ERR");
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.isAddedWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<MovieWatchlistBloc, MovieState>(
      listener: (context, state) {
        if (state is WatchlistMovieMessage) {
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
            imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
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
                                widget.movie.title,
                                style: kHeading5,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!widget.isAddedWatchlist) {
                                    context.read<MovieWatchlistBloc>().add(
                                        AddMovieWatchlist(movieDetail: widget.movie));
                                    context.read<MovieWatchlistBloc>().add(
                                        FetchMovieWatchlistStatus(
                                            id: widget.movie.id));
                                  } else {
                                    context.read<MovieWatchlistBloc>().add(
                                        RemoveMovieWatchlist(
                                            movieDetail: widget.movie));
                                    context.read<MovieWatchlistBloc>().add(
                                        FetchMovieWatchlistStatus(
                                            id: widget.movie.id));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Text(
                                _showGenres(widget.movie.genres),
                              ),
                              Text(
                                _showDuration(widget.movie.runtime),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.movie.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.movie.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.movie.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),

                              BlocBuilder<MovieRecommendationBloc, MovieState>(
                                builder: (context, state) {
                                  if (state is RecommendationMovieInitial || state is RecommendationMovieLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is RecommendationMovieError) {
                                    return Text(state.message);
                                  } else if (state is RecommendationMovieSuccess) {
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
                                                  MovieDetailPage.ROUTE_NAME,
                                                  arguments: state.movies[index].id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w500${state.movies[index].posterPath}',
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
                                        itemCount: state.movies.length,
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}


import 'package:equatable/equatable.dart';

import 'genre.dart';

class TvSeriesDetail extends Equatable{
  TvSeriesDetail({
    required this.adult,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

   bool adult;
   String? backdropPath;
   List<int> episodeRunTime;
   String firstAirDate;
   List<Genre> genres;
   String homepage;
   int id;
   bool inProduction;
   List<String> languages;
   String lastAirDate;
   String name;
   int numberOfEpisodes;
   int numberOfSeasons;
   List<String> originCountry;
   String originalLanguage;
   String originalName;
   String overview;
   double popularity;
   String? posterPath;
   String status;
   String tagline;
   String type;
   double voteAverage;
   int voteCount;

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    episodeRunTime,
    firstAirDate,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    lastAirDate,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}
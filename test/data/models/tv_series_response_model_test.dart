
import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main(){
  final tSeriesModel = TvSeriesModel(
      backdropPath: "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
      firstAirDate: "1952-12-26",
      genreIds: [10763],
      id: 94722,
      name: "Tagesschau",
      originCountry: ["DE"],
      originalLanguage: "de",
      originalName: "Tagesschau",
      overview: "German daily news program, the oldest still existing program on German television.",
      popularity: 4376.134,
      posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
      voteAverage: 7.5,
      voteCount: 135);

  final tSeriesResponseModel = TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/tv_series_on_air.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
            "first_air_date": "1952-12-26",
            "genre_ids": [
              10763
            ],
            "id": 94722,
            "name": "Tagesschau",
            "origin_country": [
              "DE"
            ],
            "original_language": "de",
            "original_name": "Tagesschau",
            "overview": "German daily news program, the oldest still existing program on German television.",
            "popularity": 4376.134,
            "poster_path": "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
            "vote_average": 7.5,
            "vote_count": 135
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });

}
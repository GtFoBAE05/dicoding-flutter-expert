import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

import 'package:http/http.dart' as http;

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl tvSeriesRemoteDataSourceImpl;
  late MockIOClient mockIOClient;

  setUp(() {
    mockIOClient = MockIOClient();
    tvSeriesRemoteDataSourceImpl =
        TvSeriesRemoteDataSourceImpl(client: mockIOClient);
  });

  group('get on air tv series', () {
    final tSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_on_air.json')))
        .tvSeriesList;

    test('should return list of tv series Model when the response code is 200',
        () async {
      // arrange
      when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series_on_air.json'), 200));
      // act
      final result = await tvSeriesRemoteDataSourceImpl.getOnAirTvSeries();
      // assert
      expect(result, equals(tSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = tvSeriesRemoteDataSourceImpl.getOnAirTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv series', () {
    final tSeriesList =
        TvSeriesResponse.fromJson(json.decode(readJson('dummy_data/tv_series_popular.json')))
            .tvSeriesList;

    test('should return list of tv series when response is success (200)',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series_popular.json'), 200));
          // act
          final result = await tvSeriesRemoteDataSourceImpl.getPopularTvSeries();
          // assert
          expect(result, tSeriesList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = tvSeriesRemoteDataSourceImpl.getPopularTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated tv series', () {
    final tSeriesList = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series_top_rated.json')))
        .tvSeriesList;

    test('should return list of tv series when response code is 200 ', () async {
      // arrange
      when(mockIOClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_series_top_rated.json'), 200));
      // act
      final result = await tvSeriesRemoteDataSourceImpl.getTopRatedTvSeries();
      // assert
      expect(result, tSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = tvSeriesRemoteDataSourceImpl.getTopRatedTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv series detail', () {
    final tId = 1;
    final tSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_series_detail.json')));

    test('should return tv series detail when the response code is 200', () async {
      // arrange
      when(mockIOClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_series_detail.json'), 200));
      // act
      final result = await tvSeriesRemoteDataSourceImpl.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = tvSeriesRemoteDataSourceImpl.getTvSeriesDetail(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get movie recommendations', () {
    final tSeriesDetail = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series_recommendations.json')))
        .tvSeriesList;
    final tId = 1;

    test('should return list of Movie Model when the response code is 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_series_recommendations.json'), 200));
          // act
          final result = await tvSeriesRemoteDataSourceImpl.getTvSeriesRecommendations(tId);
          // assert
          expect(result, equals(tSeriesDetail));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = tvSeriesRemoteDataSourceImpl.getTvSeriesRecommendations(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search tv series', () {
    final tSeriesResult = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/search_naruto_tv_series.json')))
        .tvSeriesList;
    final tQuery = 'Naruto';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockIOClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/search_naruto_tv_series.json'), 200));
      // act
      final result = await tvSeriesRemoteDataSourceImpl.searchTvSeries(tQuery);
      // assert
      expect(result, tSeriesResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = tvSeriesRemoteDataSourceImpl.searchTvSeries(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

}

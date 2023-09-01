
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main(){
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  const tId = 1;

  group("Detail Movie Test", (){
    blocTest<MovieDetailBloc, MovieState>(
      'return success when fetch success',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer((realInvocation) async  =>
            Right(testMovieDetail));
        return movieDetailBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieDetail(id: tId));
      },
      expect: () => <MovieState>[
        DetailMovieLoading(), DetailMovieSuccess(movieDetail: testMovieDetail)
      ],
    );

    blocTest<MovieDetailBloc, MovieState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer((realInvocation) async  =>
            Left(ServerFailure("404")));
        return movieDetailBloc;
      },
      act: (bloc) {
        bloc.add(FetchMovieDetail(id: tId));
      },
      expect: () => <MovieState>[
        DetailMovieLoading(), DetailMovieError(message: "404")
      ],
    );
  });


}
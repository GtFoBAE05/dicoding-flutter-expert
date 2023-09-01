import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main(){
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    tvSeriesDetailBloc = TvSeriesDetailBloc(mockGetTvSeriesDetail);
  });

  const tId = 1;

  group("Detail tv series Test", (){
    blocTest<TvSeriesDetailBloc, TvSeriesState>(
      'return success when fetch success',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((realInvocation) async  =>
            Right(testTvSeriesDetail));
        return tvSeriesDetailBloc;
      },
      act: (bloc) {
        bloc.add(FetchDetailTvSeries(id: tId));
      },
      expect: () => <TvSeriesState>[
        TvSeriesDetailLoading(), TvSeriesDetailSuccess(tvSeriesDetail: testTvSeriesDetail)
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesState>(
      'return exception when fetch failed',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer((realInvocation) async  =>
            Left(ServerFailure("404")));
        return tvSeriesDetailBloc;
      },
      act: (bloc) {
        bloc.add(FetchDetailTvSeries(id: tId));
      },
      expect: () => <TvSeriesState>[
        TvSeriesDetailLoading(), TvSeriesDetailError(message: "404")
      ],
    );
  });


}
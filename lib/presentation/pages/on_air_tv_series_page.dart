 import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../widgets/tv_series_card_list.dart';

class OnAirTvSeries extends StatefulWidget {
   static const ROUTE_NAME = "/on-air-tv-series";

   @override
   State<OnAirTvSeries> createState() => _OnAirTvSeriesState();
 }

 class _OnAirTvSeriesState extends State<OnAirTvSeries> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesOnAirBloc>().add(FetchOnAirTvSeries());
    });
  }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("On Air Tv Series"),
       ),
       body: BlocBuilder<TvSeriesOnAirBloc, TvSeriesState>(
         builder: (context, state) {
           if (state is OnAirTvSeriesInitial || state is OnAirTvSeriesLoading) {
             return Center(
               child: CircularProgressIndicator(),
             );
           } else if (state is OnAirTvSeriesSuccess) {
             return ListView.builder(
               itemBuilder: (context, index) {
                 return TvSeriesCard(state.tvSeriesList[index]);
               },
               itemCount: state.tvSeriesList.length,
             );
           } else if(state is OnAirTvSeriesError){
             return Center(
               key: Key('error_message'),
               child: Text(state.message),
             );
           }else{
             return Center(
               child: Text("ERR"),
             );
           }
         },
       )
     );
   }
 }

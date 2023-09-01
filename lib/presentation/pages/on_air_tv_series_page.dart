 import 'package:ditonton/presentation/provider/on_air_tv_series_notifier.dart';
import 'package:flutter/material.dart';
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
      context.read<OnAirTvSeriesNotifier>().fetchOnAirTvSeries();
    });
  }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("On Air Tv Series"),
       ),
       body: Consumer<OnAirTvSeriesNotifier>(
         builder: (context, value, child) {
           if (value.state == RequestState.Loading) {
             return Center(
               child: CircularProgressIndicator(),
             );
           } else if (value.state == RequestState.Loaded) {
             return ListView.builder(
               itemBuilder: (context, index) {
                 return TvSeriesCard(value.tvSeries[index]);
               },
               itemCount: value.tvSeries.length,
             );
           } else {
             return Center(
               key: Key('error_message'),
               child: Text(value.message),
             );
           }
         },
       ),
     );
   }
 }

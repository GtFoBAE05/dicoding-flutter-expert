import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';

class TvSeriesSearchPage extends StatefulWidget {
  static const ROUTE_NAME = "/search-tv-series";

  const TvSeriesSearchPage();

  @override
  State<TvSeriesSearchPage> createState() => _TvSeriesSearchPageState();
}

class _TvSeriesSearchPageState extends State<TvSeriesSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series Search'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onSubmitted: (query) {
              context
                  .read<TvSeriesSearchBloc>()
                  .add(FetchSearchTvSeries(value: query));
            },
            decoration: InputDecoration(
              hintText: 'Search Tv Series name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          BlocBuilder<TvSeriesSearchBloc, TvSeriesState>(
            builder: (context, state) {
              if (state is SearchTvSeriesLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SearchTvSeriesSuccess) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return TvSeriesCard(state.tvSeriesList[index]);
                    },
                    itemCount: state.tvSeriesList.length,
                  ),
                );
              } else if (state is SearchTvSeriesError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

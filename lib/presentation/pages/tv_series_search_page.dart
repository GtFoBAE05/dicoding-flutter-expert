import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
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
              context.read<TvSeriesSearchNotifier>().fetchTvSeriesSearch(query);
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
          Consumer<TvSeriesSearchNotifier>(
            builder: (context, value, child) {
              if (value.state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (value.state == RequestState.Loaded) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return TvSeriesCard(value.tvSeriesSearchResult[index]);
                    },
                    itemCount: value.tvSeriesSearchResult.length,
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

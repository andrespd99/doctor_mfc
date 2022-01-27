import 'package:algolia/algolia.dart';
import 'package:doctor_mfc/constants.dart';

import 'package:doctor_mfc/models/search_result.dart';

class SearchEngine {
  static final Algolia algolia = Algolia.init(
    applicationId: kApplicationId,
    apiKey: kApiKey,
  );

  Future<List<SearchResult>> searchProblem(String query) async {
    List<SearchResult> results = [];

    final algoliaQuery = algolia.instance.index('dev_PROBLEMS').query(query);
    final queryResults = await algoliaQuery.getObjects();
    // Only search if query is longer than 2 characters.
    if (query.length > 2) {
      queryResults.hits.forEach((object) {
        results.add(SearchResult.fromMap(object.data));
      });
    }

    return results;
  }
}

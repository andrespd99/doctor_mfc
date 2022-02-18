import 'package:algolia/algolia.dart';
import 'package:doctor_mfc/constants.dart';

import 'package:doctor_mfc/models/search_result.dart';

/// Search engine class that contains a list of functions to make search queries.
class SearchEngine {
  static final Algolia _algolia = Algolia.init(
    applicationId: kApplicationId,
    apiKey: kApiKey,
  );

  /// Returns a list of [SearchResult]s for the given `query`
  Future<List<SearchResult>> searchProblem(String query) async {
    List<SearchResult> results = [];

    final algoliaQuery = _algolia.instance.index('dev_PROBLEMS').query(query);
    final queryResults = await algoliaQuery.getObjects();
    // Only search if query is longer than 2 characters.
    if (query.length > 2) {
      queryResults.hits.forEach((object) {
        results.add(SearchResult.fromMap(object.data));
      });
    }

    return results;
  }

  /// Returns a list of [SearchResult]s for the given `query`, with a facet filter
  /// on entity type attribute.
  Future<List<SearchResult>> searchWithEntityTypeFacetFilter(
    String query,
    SearchEntityType type,
  ) async {
    List<SearchResult> results = [];

    final algoliaQuery = _algolia.instance
        .index('dev_PROBLEMS')
        .facetFilter('entityTypeId: ${SearchEntityTypeConverter.toCode(type)}')
        .query(query);
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

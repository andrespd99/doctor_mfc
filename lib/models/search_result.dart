import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/models/system.dart';

enum SearchEntityType {
  PROBLEM_SEARCH_RESULT,
  DOCUMENTATION_SEARCH_RESULT,
  GUIDE_SEARCH_RESULT,
}

class SearchEntityTypeConverter {
  static String toCode(SearchEntityType type) {
    switch (type) {
      case SearchEntityType.PROBLEM_SEARCH_RESULT:
        return '001';
      case SearchEntityType.DOCUMENTATION_SEARCH_RESULT:
        return '002';
      case SearchEntityType.GUIDE_SEARCH_RESULT:
        return '003';
      default:
        throw Exception('Unknown SearchEntityType: ${type.toString()}');
    }
  }

  static SearchEntityType fromCode(String code) {
    switch (code) {
      case '001':
        return SearchEntityType.PROBLEM_SEARCH_RESULT;
      case '002':
        return SearchEntityType.DOCUMENTATION_SEARCH_RESULT;
      case '003':
        return SearchEntityType.GUIDE_SEARCH_RESULT;
      default:
        throw Exception('Unknown search entity code: $code');
    }
  }
}

abstract class SearchResult {
  static final routeName = 'searchResult';

  final SearchEntityType entityType;
  final String description;

  SearchResult({required this.entityType, required this.description});

  factory SearchResult.fromMap(Map<String, dynamic> data) {
    final entityTypeId = data['entityTypeId'];
    switch (entityTypeId) {
      case '001':
        return ProblemSearchResult.fromMap(data);

      case '002':
        return DocumentationSearchResult.fromMap(data);

      case '003':
        return GuideSearchResult.fromMap(data);

      default:
        throw Exception('Unknown entity type id: $entityTypeId');
    }
  }
}

class ProblemSearchResult extends SearchResult {
  final String systemId;
  final String systemDescription;
  final String systemBrand;

  final Problem problem;

  ProblemSearchResult({
    required this.systemId,
    required this.systemDescription,
    required this.systemBrand,
    required this.problem,
  }) : super(
          entityType: SearchEntityType.PROBLEM_SEARCH_RESULT,
          description: problem.description,
        );

  factory ProblemSearchResult.fromMap(Map<String, dynamic> data) {
    return ProblemSearchResult(
      systemId: data['systemId'],
      systemDescription: data['systemDescription'],
      systemBrand: data['systemBrand'],
      problem: Problem.fromMap(data),
    );
  }
}

class DocumentationSearchResult extends SearchResult {
  final FileAttachment attachment;

  DocumentationSearchResult(this.attachment)
      : super(
          entityType: SearchEntityType.DOCUMENTATION_SEARCH_RESULT,
          description: attachment.title,
        );

  factory DocumentationSearchResult.fromMap(Map<String, dynamic> data) {
    return DocumentationSearchResult(
        new FileAttachment.fromMap(data['id'], data));
  }
}

class GuideSearchResult extends SearchResult {
  final FileAttachment attachment;

  GuideSearchResult(this.attachment)
      : super(
          entityType: SearchEntityType.GUIDE_SEARCH_RESULT,
          description: attachment.title,
        );

  factory GuideSearchResult.fromMap(Map<String, dynamic> data) {
    return GuideSearchResult(new FileAttachment.fromMap(data['id'], data));
  }
}

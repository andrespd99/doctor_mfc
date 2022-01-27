import 'package:doctor_mfc/models/solution.dart';

class Problem {
  final String id;
  final String description;

  final List<String> keywords;
  final List<Solution> solutions;

  Problem({
    required this.id,
    required this.description,
    required this.keywords,
    required this.solutions,
  });

  factory Problem.fromMap(Map<String, dynamic> data) {
    return Problem(
      id: data['id'],
      description: data['description'],
      keywords: List.from(data['keywords']),
      solutions: _solutionsFromMap(List.from(data['solutions'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'keywords': keywords,
      'userResponses': _responsesToMap(),
    };
  }

  /// Converts the List of [UserResponse]s to a json map.
  List<Map<String, dynamic>> _responsesToMap() =>
      solutions.map((response) => response.toMap()).toList();

  /// Returns a List of [Solution] objects from a json map.
  static List<Solution> _solutionsFromMap(List<Map<String, dynamic>> data) {
    return data.map((solutionData) => Solution.fromMap(solutionData)).toList();
  }
}

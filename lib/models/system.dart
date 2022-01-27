import 'package:doctor_mfc/models/problem.dart';

class System {
  final String id;
  String description;
  String brand;

  final String type;
  final List<Problem> problems;

  System({
    required this.id,
    required this.description,
    required this.type,
    required this.brand,
    required this.problems,
  });

  factory System.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return System(
      id: id,
      description: data['description'],
      type: data['type'],
      brand: data['brand'],
      problems: _problemsFromMap(List.from(data['problems'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'type': type,
      'brand': brand,
      'problems': _problemsToMap(),
    };
  }

  /// Converts a List of [Problem]s to a json map.
  List<Map<String, dynamic>> _problemsToMap() {
    return problems.map((problem) => problem.toMap()).toList();
  }

  /// Converts a json map to a List of [Problem]s.
  static List<Problem> _problemsFromMap(List<Map<String, dynamic>> data) {
    return data
        .map((Map<String, dynamic> problemData) => Problem.fromMap(problemData))
        .toList();
  }
}

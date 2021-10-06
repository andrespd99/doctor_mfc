import 'package:doctor_mfc/models/user_response.dart';

class Problem {
  final String id;
  final String description;
  final String question;
  final List<String>? solutions;
  final List<UserResponse> userResponses;

  Problem({
    required this.id,
    required this.description,
    required this.question,
    required this.userResponses,
    this.solutions,
  });

  factory Problem.fromMap({
    required String id,
    required Map<String, dynamic> data,
    required List<UserResponse> userResponses,
  }) {
    return Problem(
      id: id,
      description: data['description'],
      question: data['question'],
      solutions: List.from(data['solutions']),
      userResponses: userResponses,
    );
  }
}

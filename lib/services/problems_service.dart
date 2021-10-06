import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/user_response.dart';

class ProblemsService {
  final _db = FirebaseFirestore.instance;

  Future<Problem> getProblem(String id) async {
    Problem problem;

    final snapshot = await _db.collection('problems').doc(id).get();

    List<String> userResponseIds = List.from(snapshot['userResponses']);

    List<UserResponse> userResponses = [];

    problem = await Future.forEach(userResponseIds, (String responseId) async {
      final responseDoc =
          await _db.collection('userResponses').doc(responseId).get();

      userResponses.add(
        UserResponse.fromMap(responseId, responseDoc.data()!),
      );
    }).then((value) {
      return Problem.fromMap(
        id: id,
        data: snapshot.data()!,
        userResponses: userResponses,
      );
    });

    return problem;
  }
}

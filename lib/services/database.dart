import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/component.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/models/system.dart';

class Database {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns all system types in the database.
  Future<List<String>> getSystemTypes() async {
    final snapshot = await _db.collection('configs').doc('configs').get();

    final configs = snapshot.data();

    List<String> types = List.from(configs?['systemTypes']);

    return types;
  }

  Future<List<System>> getSystemsByType(String type) async {
    final snapshot = await _db
        .collection('systems')
        .where('type', isEqualTo: type.toLowerCase())
        .get();

    List<System> systems =
        snapshot.docs.map((doc) => System.fromMap(doc.id, doc.data())).toList();

    return systems;
  }

  Future<List<Component>> getComponents(List<String> componentsIds) async {
    var futures = componentsIds
        .map((componentId) =>
            _db.collection('components').doc(componentId).get())
        .toList();

    var snapshots = await Future.wait(futures);

    List<Component> components =
        snapshots.map((doc) => Component.fromMap(doc.id, doc.data()!)).toList();

    return components;
  }

  Future<List<Solution>> getSolutions(List<String> solutionsIds) async {
    var futures = solutionsIds
        .map((solutionId) => _db.collection('solutions').doc(solutionId).get())
        .toList();

    var snapshots = await Future.wait(futures);

    List<Solution> solutions =
        snapshots.map((doc) => Solution.fromMap(doc.id, doc.data()!)).toList();

    return solutions;
  }
}

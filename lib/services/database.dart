import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/enum/attachment_types.dart';
import 'package:doctor_mfc/models/system.dart';

class Database {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  final _systemsRef =
      FirebaseFirestore.instance.collection('systems').withConverter<System>(
            fromFirestore: (snapshot, _) => System.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (system, _) => system.toMap(),
          );

  final _fileRef = FirebaseFirestore.instance
      .collection('documents')
      .withConverter<FileAttachment>(
        fromFirestore: (snapshot, _) => FileAttachment.fromMap(
          snapshot.id,
          snapshot.data()!,
        ),
        toFirestore: (fileAttachment, _) => fileAttachment.toMap(),
      );

  /// Returns all system types in the database.
  Future<List<String>> getSystemTypes() async {
    final snapshot =
        await _db.collection('globalVariables').doc('systemTypes').get();

    final globals = snapshot.data();

    List<String> types = List.from(globals?['systemTypes']);

    return types;
  }

  Future<List<System>> getSystemsByType(String type) async {
    return _systemsRef
        .where('type', isEqualTo: type)
        .orderBy('name')
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<QuerySnapshot<System>> getSystemsSnapshotsByType(String type) =>
      _systemsRef.where('type', isEqualTo: type.toLowerCase()).snapshots();

  Future<List<FileAttachment>> getDocumentationBySystemId(String id) {
    return _fileRef
        .where('systemId', isEqualTo: id)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<QuerySnapshot<FileAttachment>> getAllDocumentationSnapshots() =>
      _fileRef
          .where('type', isEqualTo: typeToCodeMap[AttachmentType.DOCUMENTATION])
          .snapshots();

  Stream<QuerySnapshot<FileAttachment>> getAllGuidesSnapshots() => _fileRef
      .where('type', isEqualTo: typeToCodeMap[AttachmentType.GUIDE])
      .snapshots();
}

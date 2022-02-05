import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/enum/attachment_types.dart';
import 'package:doctor_mfc/models/request_form.dart';
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

  Future<List<System>> getAllSystems() async {
    return _systemsRef.get().then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<QuerySnapshot<System>> getAllSystemsSnapshots() {
    return _systemsRef.snapshots();
  }

  Future<System?> getSystemById(String id) async {
    return _systemsRef.doc(id).get().then((snapshot) {
      return snapshot.data();
    });
  }

  Stream<DocumentSnapshot<System?>> getSystemByIdSnapshot(String id) {
    return _systemsRef.doc(id).snapshots();
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
          .where('type',
              isEqualTo:
                  AttachmentTypeConverter.toCode(AttachmentType.DOCUMENTATION))
          .snapshots();

  Stream<QuerySnapshot<FileAttachment>> getAllGuidesSnapshots() => _fileRef
      .where('type',
          isEqualTo: AttachmentTypeConverter.toCode(AttachmentType.GUIDE))
      .snapshots();

  Future addRequest(RequestForm form) async {
    return await _db.collection('requests').add(form.toMap());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/app_user.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/enum/attachment_types.dart';
import 'package:doctor_mfc/models/user_request.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Database service class that contains a series of methods for interacting with the database.
class Database {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Systems collection reference with to [System] converter.
  final _systemsRef =
      FirebaseFirestore.instance.collection('systems').withConverter<System>(
            fromFirestore: (snapshot, _) => System.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (system, _) => system.toMap(),
          );

  /// Files collection reference with to [FileAttachment] converter.
  final _fileRef = FirebaseFirestore.instance
      .collection('documents')
      .withConverter<FileAttachment>(
        fromFirestore: (snapshot, _) => FileAttachment.fromMap(
          snapshot.id,
          snapshot.data()!,
        ),
        toFirestore: (fileAttachment, _) => fileAttachment.toMap(),
      );

  /// Users collection reference with to [AppUser] converter.
  final _usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (user, _) => user.toMap(),
          );

  /// Returns all system types in the database.
  Future<List<String>> getSystemTypes() async {
    final snapshot =
        await _db.collection('globalVariables').doc('systemTypes').get();

    final globals = snapshot.data();

    List<String> types = List.from(globals?['systemTypes']);

    return types;
  }

  /// Returns all systems in Firebase Firestore.
  Future<List<System>> getAllSystems() async {
    return _systemsRef.get().then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Returns a Stream of all systems in Firebase Firestore.
  Stream<QuerySnapshot<System>> getAllSystemsSnapshots() {
    return _systemsRef.snapshots();
  }

  /// Returns the system with the given `id`.
  Future<System?> getSystemById(String id) async {
    return _systemsRef.doc(id).get().then((snapshot) {
      return snapshot.data();
    });
  }

  /// Returns a Stream of the system with the given `id`.
  Stream<DocumentSnapshot<System?>> getSystemByIdSnapshot(String id) {
    return _systemsRef.doc(id).snapshots();
  }

  /// Returns all systems of the given `type` in Firebase Firestore.
  Future<List<System>> getSystemsByType(String type) async {
    return _systemsRef
        .where('type', isEqualTo: type)
        .orderBy('name')
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Returns a Stream of all systems of given `type` in Firebase Firstore.
  Stream<QuerySnapshot<System>> getSystemsSnapshotsByType(String type) =>
      _systemsRef.where('type', isEqualTo: type.toLowerCase()).snapshots();

  /// Returns the list of all the documentation of a system.
  ///
  /// `id` is the id of the system.
  Future<List<FileAttachment>> getDocumentationBySystemId(String id) {
    return _fileRef
        .where('systemId', isEqualTo: id)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Returns a Stream of all the documentation in Firebase Firestore.
  Stream<QuerySnapshot<FileAttachment>> getAllDocumentationSnapshots() =>
      _fileRef
          .where('type',
              isEqualTo:
                  AttachmentTypeConverter.toCode(AttachmentType.DOCUMENTATION))
          .snapshots();

  /// Returns a Stream of all guides in Firebase Firestore.
  Stream<QuerySnapshot<FileAttachment>> getAllGuidesSnapshots() => _fileRef
      .where('type',
          isEqualTo: AttachmentTypeConverter.toCode(AttachmentType.GUIDE))
      .snapshots();

  /// Adds the user request to Firebase Firestore and returns the future of this
  /// action.
  Future addRequest(UserRequest request) async {
    return await _db.collection('requests').add(request.toMap());
  }

  /// Returns the [DocumentSnapshot] of [AppUser] associated with the provided `id`.
  Future<DocumentSnapshot<AppUser>> getUserDocByEmail(String email) => _usersRef
          .where('userEmail', isEqualTo: email)
          .limit(1)
          .get()
          .then((result) {
        // Assert that no more than one user has the given email.
        assert(result.docs.length <= 1);

        // Check if the user is registered.
        if (result.docs.isEmpty) {
          // If it's not registered, throw a FirebaseAuthException.
          throw FirebaseAuthException(code: 'invalid-email');
        } else
          return result.docs.first;
      });
}

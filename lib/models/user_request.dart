import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/entity_type.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/request_type.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/models/system.dart';

class UserRequest {
  String userId;
  String userEmail;

  /// Time when the request has been created.
  Timestamp timestamp;

  /// Type of request, can be either ADD or UPDATE.
  RequestType requestType;

  /// Entity type to be the changed.
  EntityType entityType;

  /// This is only not-null when the `requestType` is [RequestType.ADD] and the `entityType` is [EntityType.SYSTEM].
  String? systemNameToAdd;

  /// This is only used when the `requestType` is [RequestType.ADD] and the `entityType` is [EntityType.SYSTEM].
  /// Can be null.
  String? systemBrandToAdd;

  /// This is only not-null when the `requestType` is [RequestType.UPDATE] and the `entityType` is [EntityType.SYSTEM].
  System? systemToUpdate;

  /// This is only not-null when the `requestType` is [RequestType.UPDATE] and the `entityType` is [EntityType.PROBLEM].
  Problem? problemToUpdate;

  /// This is only not-null when the `requestType` is [RequestType.UPDATE] and the `entityType` is [EntityType.SOLUTION].
  Solution? solutionToUpdate;

  /// Title of the request. Useful to summarize the request.
  String requestTitle;

  /// Description of the request. Should have all the details of the change
  /// that the user wants to suggest.
  String requestDescription;

  UserRequest({
    required this.requestType,
    required this.entityType,
    required this.requestTitle,
    required this.requestDescription,
    required this.userId,
    required this.userEmail,
    this.systemNameToAdd,
    this.systemBrandToAdd,
    this.systemToUpdate,
    this.problemToUpdate,
    this.solutionToUpdate,
  }) : timestamp = Timestamp.now();

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'requestType': RequestTypeConverter.typeToString(requestType),
        'entityType': EntityTypeConverter.typeToString(entityType),
        'requestTitle': requestTitle,
        'requestDescription': requestDescription,
        'reviewed': false,
        if (systemNameToAdd != null && systemNameToAdd!.isNotEmpty)
          'systemNameToAdd': systemNameToAdd,
        if (systemBrandToAdd != null && systemBrandToAdd!.isNotEmpty)
          'systemBrandToAdd': systemBrandToAdd,
        if (systemToUpdate != null)
          'systemToUpdate': systemToUpdate!.description,
        if (problemToUpdate != null)
          'problemToUpdate': problemToUpdate!.description,
        if (solutionToUpdate != null)
          'solutionToUpdate': solutionToUpdate!.description,
        'timestamp': timestamp,
      };
}

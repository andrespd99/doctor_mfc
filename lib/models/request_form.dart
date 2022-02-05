import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/models/entity_type.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/request_type.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/models/system.dart';

class RequestForm {
  String userId;
  Timestamp timestamp;

  RequestType requestType;
  EntityType entityType;
  String? systemNameToAdd;
  String? systemBrandToAdd;

  System? systemToUpdate;
  Problem? problemToUpdate;
  Solution? solutionToUpdate;

  String requestTitle;
  String requestDescription;

  RequestForm({
    required this.requestType,
    required this.entityType,
    required this.requestTitle,
    required this.requestDescription,
    required this.userId,
    this.systemNameToAdd,
    this.systemBrandToAdd,
    this.systemToUpdate,
    this.problemToUpdate,
    this.solutionToUpdate,
  }) : timestamp = Timestamp.now();

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'requestType': RequestTypeConverter.typeToString(requestType),
        'entityType': EntityTypeConverter.typeToString(entityType),
        'requestTitle': requestTitle,
        'requestDescription': requestDescription,
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

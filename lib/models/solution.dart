import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/guide_link.dart';
import 'package:doctor_mfc/models/step.dart';

class Solution {
  final String id;
  final String description;

  final String? instructions;

  final List<Step>? steps;
  final List<Attachment>? attachments;

  Solution({
    required this.id,
    required this.description,
    // required this.problemDescription,
    this.instructions,
    this.attachments,
    this.steps,
  });

  factory Solution.fromMap(Map<String, dynamic> data) {
    return Solution(
      id: data['id'],
      description: data['description'],
      instructions: data['instructions'],
      steps: _getStepsFromMap(List.from(data['steps'] ?? [])),
      attachments: _getAttachmentsFromMap(List.from(data['attachments'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    steps?.removeWhere((step) => step.description.isEmpty);

    return {
      'id': id,
      'description': description,
      'instructions': instructions,
      'steps': steps?.map((step) => step.toMap()).toList(),
      'attachments': attachments?.map((attachment) {
        if (attachment is LinkAttachment)
          return attachment.toMap();
        else if (attachment is FileAttachment) return attachment.toMap();
      }).toList(),
    };
  }

  /// Returns a List of [Step] from a json map.
  static List<Step> _getStepsFromMap(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data.map((stepsData) => Step.fromMap(stepsData)).toList();
    else
      return [];
  }

  /// Returns a List of [Attachment] objects from a json map.
  static List<Attachment> _getAttachmentsFromMap(
      List<Map<String, dynamic>> data) {
    return data
        .map((attachmentsData) => Attachment.fromMap(attachmentsData))
        .toList();
  }

  /// Returns a List of [GuideLink] from a json map.
  static List<GuideLink> _getLinksFromMap(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data.map((linkData) => GuideLink.fromMap(linkData)).toList();
    else
      return [];
  }
}

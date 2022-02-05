import 'package:doctor_mfc/models/enum/attachment_types.dart';

abstract class Attachment {
  AttachmentType type;
  String title;

  Attachment({
    required this.type,
    required this.title,
  });

  factory Attachment.fromMap(Map<String, dynamic> data) {
    if (AttachmentTypeConverter.fromCode(data['type']) == AttachmentType.LINK) {
      return LinkAttachment(
        title: data['title'],
        url: data['url'],
      );
    } else {
      return FileAttachment.fromMap(data['id'], data);
    }
  }
}

class FileAttachment extends Attachment {
  String id;
  String fileName;
  int fileSize;
  String fileUrl;

  String? systemId;
  String? systemBrand;
  String? systemDescription;

  FileAttachment({
    required AttachmentType type,
    required String title,
    required this.id,
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    this.systemId,
    this.systemBrand,
    this.systemDescription,
  })  : assert((type == AttachmentType.DOCUMENTATION && systemId != null) ||
            type != AttachmentType.DOCUMENTATION),
        super(
          title: title,
          type: type,
        );

  factory FileAttachment.fromMap(String id, Map<String, dynamic> data) {
    return FileAttachment(
      id: id,
      systemId: data['systemId'],
      systemBrand: data['systemBrand'],
      systemDescription: data['systemDescription'],
      type: AttachmentTypeConverter.fromCode(data['type'] as String)!,
      title: data['title'],
      fileUrl: data['fileUrl'],
      fileName: data['fileName'],
      fileSize: data['fileSize'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (type == AttachmentType.DOCUMENTATION) 'systemId': systemId,
      'type': AttachmentTypeConverter.toCode(type),
      'title': title,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileUrl': fileUrl,
    };
  }
}

class LinkAttachment extends Attachment {
  String url;

  LinkAttachment({
    required String title,
    required this.url,
  }) : super(
          title: title,
          type: AttachmentType.LINK,
        );

  Map<String, dynamic> toMap() {
    assert(title.isNotEmpty);
    assert(url.isNotEmpty);

    return {
      'title': title,
      'url': url,
      'type': AttachmentTypeConverter.toCode(type),
    };
  }
}

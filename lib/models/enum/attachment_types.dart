enum AttachmentType { DOCUMENTATION, GUIDE, LINK }

class AttachmentTypeConverter {
  static toCode(AttachmentType type) {
    switch (type) {
      case AttachmentType.DOCUMENTATION:
        return '001';
      case AttachmentType.GUIDE:
        return '002';
      case AttachmentType.LINK:
        return '003';
      default:
        throw new Exception('Unknown AttachmentType: ${type.toString()}');
    }
  }

  static fromCode(String code) {
    switch (code) {
      case '001':
        return AttachmentType.DOCUMENTATION;
      case '002':
        return AttachmentType.GUIDE;
      case '003':
        return AttachmentType.LINK;
      default:
        throw new Exception('Unknown AttachmentType code: $code');
    }
  }
}

class Solution {
  final String id;
  final String instructions;
  final String? guideLink;
  final String? imageUrl;

  Solution({
    required this.id,
    required this.instructions,
    this.guideLink,
    this.imageUrl,
  });

  factory Solution.fromMap(String id, Map<String, dynamic> data) {
    return Solution(
      id: id,
      instructions: data['instructions'],
      guideLink: data['guideLink'],
      imageUrl: data['imageUrl'],
    );
  }
}

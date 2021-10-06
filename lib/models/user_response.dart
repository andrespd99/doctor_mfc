class UserResponse {
  final String id;
  final String description;
  final bool isOkResponse;
  List<String>? solutions;

  UserResponse({
    required this.id,
    required this.description,
    this.isOkResponse = false,
    this.solutions,
  });

  factory UserResponse.fromMap(String id, Map<String, dynamic> data) {
    return UserResponse(
      id: id,
      description: data['description'],
      solutions: List.from(data['solutions'] ?? []),
      isOkResponse: data['isOkResponse'] ?? false,
    );
  }
}

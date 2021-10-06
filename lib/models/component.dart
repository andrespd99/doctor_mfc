class Component {
  final String id;
  final String description;
  final List<String> problemsIds;

  Component({
    required this.id,
    required this.description,
    required this.problemsIds,
  });

  factory Component.fromMap(String id, Map<String, dynamic> data) {
    return Component(
      id: id,
      description: data['description'],
      problemsIds: List.from(data['problems']),
    );
  }
}

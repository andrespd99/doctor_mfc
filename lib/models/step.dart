/// [Solution]'s steps, only for step-based solutions.
class Step {
  String description;
  List<String> substeps;

  Step({required this.description, List<String>? substeps})
      : this.substeps = substeps ?? [];

  factory Step.fromMap(Map<String, dynamic> data) {
    return Step(
      description: data['description'] as String,
      substeps: List<String>.from(data['substeps'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    substeps.removeWhere((substep) => substep.isEmpty);

    return {
      'description': description,
      'substeps': substeps,
    };
  }
}

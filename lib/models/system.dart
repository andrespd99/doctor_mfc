import 'package:doctor_mfc/models/component.dart';

class System {
  final String id;
  final String description;
  final String type;
  final String brand;
  final List<String> componentsIds;

  System(
      {required this.id,
      required this.description,
      required this.type,
      required this.brand,
      required this.componentsIds});

  factory System.fromMap(String id, Map<String, dynamic> data) {
    return System(
      id: id,
      description: data['description'],
      type: data['type'],
      brand: data['brand'],
      componentsIds: List.from(data['components']),
    );
  }
}

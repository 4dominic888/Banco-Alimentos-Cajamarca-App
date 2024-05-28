import 'package:double_linked_list/double_linked_list.dart';

class Ubication {
  final Map<String,String> country;
  final String type;
  final DoubleLinkedList< Map<String, Map<String,String?> > >? subPlaces;

  Ubication({required this.country, required this.type, this.subPlaces});

  @override
  String toString() {
    return """country: ${country['codigo']}-${country['nombre']}
    ${subPlaces.toString()}""";
  }
}
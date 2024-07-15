import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';
import 'package:double_linked_list/double_linked_list.dart';

class InternationalUbication extends Ubication {
  final List<Map<String, Map<String,String?>>> places;

  InternationalUbication(Map<String,String> country, this.places) : 
    super(type: 'international', country: country, subPlaces: places.toDoubleLinkedList());
}
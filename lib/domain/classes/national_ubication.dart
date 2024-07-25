import 'package:bancalcaj_app/domain/classes/ubication.dart';
import 'package:double_linked_list/double_linked_list.dart';

class NationalUbication extends Ubication {

  final List<Map<String, Map<String,String?>>> places;
  NationalUbication(this.places) : 
    super(type: 'national', country: {'codigo':'604', 'nombre':'Peru'}, subPlaces: places.toDoubleLinkedList());
}
import 'package:cloud_firestore/cloud_firestore.dart';

extension MappingBeach on QuerySnapshot {
  List<Map<String, dynamic>> toBeach() {
    // ignore: omit_local_variable_types
    List<Map<String, dynamic>> beaches = [];
    docs.forEach((element) {
      beaches.add(element.data() as Map<String, dynamic>);
    });
    return beaches;
  }
}

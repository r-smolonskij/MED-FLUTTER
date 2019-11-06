//class Field {
//  int id;
//  String titleLV;
//  String titleENG;
//
//  Field(this.id, this.titleLV, this.titleENG);
//
//  Map<String, dynamic> toMap(){
//    var map = <String, dynamic>{
//      'id': id,
//      'titleLV': titleLV,
//      'titleENG': titleENG,
//    };
//    return map;
//  }
//  String getTitleLV(){
//    return titleLV;
//  }
//
//  Field.fromMap(Map<String, dynamic> map) {
//    id = map ['id'];
//    titleLV = map ['titleLV'];
//    titleENG = map ['titleENG'];
//  }
//
//}
class Field {
  int fieldID;
  String field;


  Field(this.fieldID, this.field);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'field': field,
      'fieldID': fieldID,
    };
    return map;
  }

  Field.fromMap(Map<String, dynamic> map) {
    field = map ['field'];
    fieldID = map ['fieldID'];
  }

}


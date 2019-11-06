class Object {
  int wordID;
  String wordLV;
  String wordENG;
  String field;
  int fieldID;
  String type;


  Object(this.wordID, this.wordLV, this.wordENG, this.type, this.field, this.fieldID);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'wordID': wordID,
      'wordLV': wordLV,
      'wordENG': wordENG,
      'type': type,
      'field': field,
      'fieldID': fieldID,
    };
    return map;
  }
  String getField(){
    return field;
  }

  Object.fromMap(Map<String, dynamic> map) {
    wordID = map ['wordID'];
    wordLV = map ['wordLV'];
    wordENG = map ['wordENG'];
    type = map ['type'];
    field = map ['field'];
    fieldID = map ['fieldID'];
  }

}
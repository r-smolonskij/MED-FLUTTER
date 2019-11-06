//class Word {
//  int id;
//  String wordLV;
//  String wordENG;
//  int typeID;
//
//  Word(this.id, this.wordLV, this.wordENG, this.typeID);
//
//  Map<String, dynamic> toMap(){
//    var map = <String, dynamic>{
//      'id': id,
//      'wordLV': wordLV,
//      'wordENG': wordENG,
//      'typeID': typeID,
//    };
//    return map;
//  }
//
//  Word.fromMap(Map<String, dynamic> map) {
//    id = map ['id'];
//    wordLV = map ['wordLV'];
//    wordENG = map ['wordENG'];
//    typeID = map ['typeID'];
//  }
//
//}
class Word {
  int wordID;
  String wordLV;
  String wordENG;
  String type;

  Word(this.wordID, this.wordLV, this.wordENG, this.type);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'wordID': wordID,
      'wordLV': wordLV,
      'wordENG': wordENG,
      'type': type,
    };
    return map;
  }

  Word.fromMap(Map<String, dynamic> map) {
    wordID = map ['wordID'];
    wordLV = map ['wordLV'];
    wordENG = map ['wordENG'];
    type = map ['type'];
  }

}
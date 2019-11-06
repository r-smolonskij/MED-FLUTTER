class WordsFieldsRelationship {
  int relationshipID;
  String wordsID;
  String fieldsID;

  WordsFieldsRelationship(this.relationshipID, this.wordsID, this.fieldsID);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'relationshipID': relationshipID,
      'wordsID': wordsID,
      'fieldsID': fieldsID,
    };
    return map;
  }

  WordsFieldsRelationship.fromMap(Map<String, dynamic> map) {
    relationshipID = map ['relationshipID'];
    wordsID = map ['wordsID'];
    fieldsID = map ['fieldsID'];
  }

}
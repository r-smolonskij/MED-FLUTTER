import 'package:flutter/material.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/field.dart';
import 'package:med/sqlite/word.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';

class WritingGame extends StatefulWidget {
  final int fieldID;
  WritingGame(this.fieldID);

  @override
  _WritingGameState createState() => _WritingGameState();
}

class _WritingGameState extends State<WritingGame> {
  Future<Word> _getRandomWord() async {
    if (canChangeWord) {
      var rng = new Random();
      //Field field = await dbHelper.getFieldByID(widget.fieldID);
      List<Word> words = await dbHelper.getWordsByFieldID(widget.fieldID);
      randomWord =
          await dbHelper.getWordByID(words[rng.nextInt(words.length)].wordID);
      canChangeWord = false;
    }
    return randomWord;
  }

  bool canChangeWord = true;
  int randomNumber = 0;
  Field field;
  DatabaseHelper dbHelper = DatabaseHelper();
  Word randomWord;

  @override
//  void initState() {
//    super.initState();
//    setState(() {
//      print(widget.fieldID);
//      dbHelper.getFieldByID(widget.fieldID).then((field) {
//        dbHelper.getWordsByFieldID(field.fieldID).then((words) {
//          var rng = new Random();
//          dbHelper.getWordByID(words[rng.nextInt(words.length)].wordID).then((word) {
//            print(word.wordLV);
//            randomWord = word;
//          });
//        });
//      });
//    });
//  }
  Widget instructionText(Word word) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    String type = word.type;
    if (languageBloc.isLatvian) {
      if (type == 'V') {
        return Text(
          'Uzrakstiet šo vārdu/frāzi angļu valodā: "' + word.wordLV + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'J') {
        return Text(
          'Uzrakstiet šo jautājumu angļu valodā: "' + word.wordLV + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'N') {
        return Text(
          'Uzrakstiet šo norādījumu angļu valodā: "' + word.wordLV + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      }
    } else {
      if (type == 'V') {
        return Text(
          'Write this word/phrase in Latvian: "' + word.wordENG + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'J') {
        return Text(
          'Write this question in Latvian: "' + word.wordENG + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'N') {
        return Text(
          'Write this instruction in Latvian: "' + word.wordENG + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      }
    }
  }

  Future<bool> checkAnswer(String answer, Word word) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    String correctAnswer = languageBloc.isLatvian ? word.wordENG.replaceAll(new RegExp("\\(.*?\\)"), "") : word.wordLV.replaceAll(new RegExp("\\(.*?\\)"), "");
    if (answer.toLowerCase() == correctAnswer.toLowerCase()) {
      return Alert(
        context: context,
        title: languageBloc.isLatvian ? "Pareizi" : 'Correct Answer',
        type: AlertType.success,
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
        ),
        buttons: [
          DialogButton(
            child: Text(
              languageBloc.isLatvian ? "NĀKOŠAIS" : 'NEXT',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WritingGame(widget.fieldID))),
            onPressed: () {
              canChangeWord = true;
              answerController.text = '';
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    } else {
      return Alert(
        context: context,
        title: languageBloc.isLatvian ? "Nepareizi" : 'Wrong Answer',
        type: AlertType.error,
        desc: languageBloc.isLatvian
            ? 'Pareizā atbilde: ' + correctAnswer
            : 'Correct answer: ' + correctAnswer,
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
        ),
        buttons: [
          DialogButton(
            child: Text(
              languageBloc.isLatvian ? "NĀKOŠAIS" : 'NEXT',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              canChangeWord = true;
              answerController.text = '';
              Navigator.pop(context);
            },
            //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WritingGame(widget.fieldID))),
          )
        ],
      ).show();
    }
  }

  TextEditingController answerController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: languageBloc.isLatvian
            ? Text('"Uzraksti pareizi"')
            : Text('Writing Game'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getRandomWord(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return Container(
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: instructionText(snapshot.data),
                    ),
                    TextField(
                      controller: answerController,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        focusColor: Colors.deepPurple,
                        hintText: languageBloc.isLatvian
                            ? 'Ievadiet šeit atbildi'
                            : 'Enter here answer',
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        prefixIcon: Icon(Icons.add_box),
                        labelText:
                            languageBloc.isLatvian ? 'Atbilde' : 'Answer',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        autofocus: true,
                        onPressed: () {
                          checkAnswer(answerController.text, snapshot.data);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            languageBloc.isLatvian
                                ? 'Iesniegt atbildi'
                                : 'Submit answer',
                            style: new TextStyle(
                              fontSize: 27.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

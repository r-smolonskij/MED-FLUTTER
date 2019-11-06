//import 'package:app/sqlite/db_helper.dart';
/*
import 'package:flutter/material.dart';
import 'package:med/sqlite/db_helper.dart';
import 'package:med/sqlite/db_seeder.dart';
import 'sqlite/field.dart';
import 'sqlite/word.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Field>> fields;
  Future<List<Word>> words;
  var field;
  var word;
  TextEditingController controller = TextEditingController();
  String name;
  int curUserId;
  int count;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  var dbSeeder;
  bool isUpdating;

  @override

  void initState(){
    super.initState();
    dbHelper = DBHelper();
    dbSeeder = DBSeeder();
    isUpdating = false;
    setCount();
    refreshList();
  }
  void setCount() async{
    count = await dbHelper.getWordsCount();
    field = await dbHelper.getFieldByID(10018);
    word = await dbHelper.getWordByID(1);
    print(await count);
    print(await field.titleLV);
    print(await word.wordLV);
  }

  refreshList(){
    setState(() {
      //fields = dbHelper.getFields();
      //words = dbHelper.getWords();
      fields = dbHelper.getFieldsByWordID(1);
      //field = dbHelper.getFieldByID(10018);
    });
  }


  clearName(){
    controller.text ='';
  }

  validate(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      if(isUpdating){
        Field e = Field(curUserId, '', '');
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      }else{
        //dbSeeder.wordsSeed();
        //dbSeeder.fieldsSeed();
        /*
        Field e = Field(11, name, 'sssss');
        dbHelper.saveField(e);
        print(e.titleLV);*/
      }
      clearName();
      refreshList();
    }
  }

  form(){
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: ''),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Field> fields) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: fields
            .map(
              (field) => DataRow(
              cells: [
                DataCell(
                  Text(''),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = field.id;
                    });
                    controller.text = field.titleLV.toString();
                  },
                ),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.delete(field.id);
                    refreshList();
                  },
                )),
              ]),
        )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: fields,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}*/

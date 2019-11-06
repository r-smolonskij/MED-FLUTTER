import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med/sqlite/db_helper.dart';
import 'package:med/sqlite/field.dart';
import 'field_single.dart';
import 'package:med/drawer.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';

class FieldsPage extends StatefulWidget {
  @override
  _FieldsPageState createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  List<Field> fields = List();
  //DBHelper dbHelper = DBHelper();
  DatabaseHelper dbHelper2 = DatabaseHelper();
  void initState() {
    super.initState();
    setState(() {
      dbHelper2.getFields().then((fieldsFromDB) {
        setState(() {
          fields = fieldsFromDB;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: languageBloc.isLatvian ? Text('Medicīnas nozares') : Text('Fields Of Medicine'),
      ),
      drawer: MyDrawer(),

      body: Column(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Expanded(
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FieldSingle(fields[index].fieldID))),
                  child: Card(
                    shape: BeveledRectangleBorder(
                      side: BorderSide(
                        color: Colors.deepPurple,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            languageBloc.isLatvian ? fields[index].field : fields[index].field+' ENG',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

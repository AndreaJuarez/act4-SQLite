import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';


class Delete extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Delete> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Student>> Studentss;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_matricula = TextEditingController();
  String name;
  String lastname1;
  String lastname2;
  String email;
  String phone;
  String matricula;
  int currentUserId;

  var dbHelper;
  bool isUpdating;
  final formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void ready(){
    setState(() {
      _showSnackBar(context,"Datos eliminados con éxito!");
    });
  }

  void cleanData() {
    controller_name.text = "";
    controller_lastname1.text = "";
    controller_lastname2.text = "";
    controller_phone.text = "";
    controller_email.text = "";
    controller_matricula.text = "";
  }

  //MOSTRAR DATOS
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Delete"),
          ),
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("A. Paterno"),
          ),
          DataColumn(
            label: Text("A. Materno"),
          ),
          DataColumn(
            label: Text("E-mail"),
          ),
          DataColumn(
            label: Text("Telefono"),
          ),
          DataColumn(
            label: Text("Matricula"),
          ),
        ],
        rows: Studentss.map((student) => DataRow(cells: [
          //DataCell(Text(student.controlnum.toString())),
          DataCell(IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              dbHelper.delete(student.controlnum);
              refreshList();
              ready();
            },
          )),
          DataCell(Text(student.name.toString().toUpperCase())),
          DataCell(Text(student.lastname1.toString().toUpperCase())),
          DataCell(Text(student.lastname2.toString().toUpperCase())),
          DataCell(Text(student.email.toString().toUpperCase())),
          DataCell(Text(student.phone.toString().toUpperCase())),
          DataCell(Text(student.matricula.toString().toUpperCase())),
        ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("DELETE DATA"),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: new Container(
        child: new Padding(
            padding: EdgeInsets.all(20.0),
            child: new Column(
                children: <Widget>[
                  list(),
                ]
            )
        ),
      ),
    );
  }
  //Snackbar
  _showSnackBar(BuildContext, String texto) {
    final snackBar = SnackBar(
        content: new Text(texto)
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

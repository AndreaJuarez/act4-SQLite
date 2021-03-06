import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Select> {
  Future<List<Student>> Studentss;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email= TextEditingController();
  TextEditingController controller_matricula = TextEditingController();
  TextEditingController controller_busqueda = TextEditingController();

  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;
  String search;

  int currentUserId;

  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.Busqueda(controller_busqueda.text);
    });
  }

  void cleanData() {
    controller_busqueda.text = "";
  }

  /* void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }


  Widget form(){
    return Form(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: new Column(
          children: <Widget>[
            TextFormField(
              controller: controller_busqueda,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Busqueda por matricula'),
              validator: (val) => val.length == 0 ? 'Inserte una matricula por favor' : null,
              onSaved: (val) => matricula = val,
            ),
            MaterialButton(
              color: Colors.cyan[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.cyan[700]),
              ),
              onPressed: buscarMatricula,
              child: Text('Search',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }*/

//SHOW DATA
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Nombre"),
          ),
          DataColumn(
            label: Text("A. Paterno"),
          ),
          DataColumn(
            label: Text("A. Materno"),
          ),
          DataColumn(
            label: Text("Telefono"),
          ),
          DataColumn(
            label: Text("Email"),
          ),
          DataColumn(
            label: Text("Matricula"),
          ),
        ],
        rows: Studentss.map((student) =>
            DataRow(cells: [
              //NOMBRE
              DataCell(Text(student.name.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_name.text = student.name;
                  }),
              //APELLIDO PATERNO
              DataCell(Text(student.lastname1.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_lastname1.text= student.lastname1;
                  }),
              //APELLIDO MATERNO
              DataCell(Text(student.lastname2.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_lastname2.text= student.lastname2;
                  }),
              //TELEFONO
              DataCell(Text(student.phone.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      name = student.name;
                    });
                    controller_phone.text = student.phone;
                  }),
              //EMAIL
              DataCell(Text(student.email.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_email.text = student.email;
                  }),
              //MATRICULA
              DataCell(Text(student.matricula.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_matricula.text = student.matricula;
                  }),
            ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomInset: false,   //new line
      appBar: AppBar(
        title: isUpdating ? TextField(
          autofocus: true,
          controller: controller_busqueda,
          onChanged: (text){
            refreshList();
          })
            : Text("SELECT DATA BY MATRICULA"),
        leading: IconButton(
          icon: Icon(isUpdating ? Icons.done: Icons.search),
          onPressed: () {
            print("Is typing" + isUpdating.toString());
            setState(() {
              isUpdating = !isUpdating;
              //refreshList();
              controller_busqueda.text = "";
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[800],
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //form(),
            list(),
          ],
        ),
      ),
    );
  }
}
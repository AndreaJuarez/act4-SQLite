import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Update> {
  //Variable referentes al manejo de la BD
  Future<List<Student>> Studentss;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email= TextEditingController();
  TextEditingController controller_matricula = TextEditingController();

  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;

  String valor;
  int currentUserId;
  int opcion;


  String descriptive_text = "Student Name";

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

  //select
  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
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
  }*/


  //Student e = Student(curUserId, name);

  void updateData(){
    print("Valor de Opción");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      //NOMBRE
      if (opcion==1) {
        Student stu = Student(currentUserId, valor, lastname1, lastname2, phone, email, matricula);
        dbHelper.update(stu);
      }
      //APELLIDO PATERNO
      else if (opcion==2) {
        Student stu = Student(currentUserId, name, valor, lastname2, phone, email, matricula);
        dbHelper.update(stu);
      }
      //APELLIDO MATERNO
      else if (opcion==3) {
        Student stu = Student(currentUserId, name, lastname1, valor, phone, email, matricula);
        dbHelper.update(stu);
      }
      //PHONE
      else if (opcion==4) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, valor, email, matricula);
        dbHelper.update(stu);
      }
      //EMAIL
      else if (opcion==5) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, phone, valor, matricula);
        dbHelper.update(stu);
      }
      //MATRICULA
      else if (opcion==6) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, phone, email, valor);
        dbHelper.update(stu);
      }
      cleanData();
      refreshList();
    }
  }

  void insertData() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      {
        Student stu = Student(null, name, lastname1, lastname2, phone, email, matricula);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }
  //Formulario

  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 50.0),
            TextFormField(
              controller: controller_name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text),
              validator: (val) => val.length == 0 ? 'Enter Data' : null,
              onSaved: (val) => valor = val,
            ),
            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: updateData,
                  //child: Text(isUpdating ? 'Update ' : 'Add Data'),
                  child: Text('Update Data'),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    cleanData();
                    refreshList();
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



//Mostrar datos
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
              //NOMBRE 1
              DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Nombre";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  opcion=1;
                });
                controller_name.text = student.name;
              }),
              //APELLIDO PATERNO 2
              DataCell(Text(student.lastname1.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Apellido Paterno";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  opcion=2;
                });
                controller_lastname1.text= student.lastname1;
              }),
              //APELLIDO MATERNO 3
              DataCell(Text(student.lastname2.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Apellido Materno";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  opcion=3;
                });
                controller_lastname2.text= student.lastname2;
              }),
              //TELEFONO 4
              DataCell(Text(student.phone.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Telefono";
                  name = student.name;
                  currentUserId = student.controlnum;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  opcion=4;
                });
                controller_phone.text = student.phone;
              }),
              //EMAIL 5
              DataCell(Text(student.email.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "E-mail";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  opcion=5;
                });
                controller_email.text = student.email;
              }),
              //MATRICULA 6
              DataCell(Text(student.matricula.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Matricula";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  opcion=6;
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
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: Text('UPDATE DATA'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}

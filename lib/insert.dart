import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';

class Insert extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Insert> {
  //VARIABLES REFERENTES AL MANEJO DE LA BD
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Student>> Studentss;

  //CONTROLLERS
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_matricula = TextEditingController();

  int currentUserId;
  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating; //PARA SABER ESTADO ACTUAL DE LA CONSULTA

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

  /*void ready(){
    setState(() {
      _showSnackBar(context,"Datos guardados con éxito!");
    });
  }*/

  void cleanData() {
    controller_name.text = "";
    controller_lastname1.text = "";
    controller_lastname2.text = "";
    controller_phone.text = "";
    controller_email.text = "";
    controller_matricula.text = "";
  }

  void dataValidate() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Student stu = Student(
            currentUserId, name, lastname1, lastname2, phone, email, matricula);
        //dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu =
            Student(null, name, lastname1, lastname2, phone, email, matricula);

        //VALIDACION PARA REGISTRO DE DATOS
        var validation = await dbHelper.validateInsert(stu);
        print(validation);
        if (validation) {
          dbHelper.insert(stu);
          final snackBar = SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text('Datos ingresados correctamente!'),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
          }else{
          final snackBar = SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text('Matricula en uso, intentalo de nuevo!'),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
      //LIMPIA DESPUES DE EJECUTAR LA CONSULTA
      cleanData();
      refreshList();
      //ready();
    }
  }

  //FORMULARIO
  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 10.0),
            //TEXT FIELD PARA DATOS DEL FORMULARIO
            TextFormField(
              controller: controller_name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Nombre"),
              validator: (val) => val.length == 0 ? 'Por favor inténtelo de nuevo' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: controller_lastname1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Apellido Paterno"),
              validator: (val) => val.length == 0 ? 'Por favor inténtelo de nuevo' : null,
              onSaved: (val) => lastname1 = val,
            ),
            TextFormField(
              controller: controller_lastname2,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Apellido Materno"),
              validator: (val) => val.length == 0 ? 'Por favor inténtelo de nuevo' : null,
              onSaved: (val) => lastname2 = val,
            ),
            TextFormField(
              controller: controller_email,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "E-mail"),
              validator: (val) => !val.contains('@') ? 'Correo incorrecto, inténtalo de nuevo' : null,
              onSaved: (val) => email = val,
            ),
            TextFormField(
              controller: controller_phone,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Telefono"),
              validator: (val) => val.length == 0 ? 'Enter name' : null,
              onSaved: (val) => phone = val,
            ),
            TextFormField(
              controller: controller_matricula,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Matricula"),
              validator: (val) => val.length == 0 ? 'Enter name' : null,
              onSaved: (val) => matricula = val,
            ),
            SizedBox(height: 30),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: dataValidate,
                  //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                  child: Text(isUpdating ? 'Update' : 'Add Data'),
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

  //MOSTRAR DATOS
  /*SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
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
          /*DataColumn(
            label: Text("Delete"),
          ),*/
        ],
        rows: Studentss.map((student) => DataRow(cells: [
              //DataCell(Text(student.controlnum.toString())),
              DataCell(Text(student.name)),
              DataCell(Text(student.lastname1.toString())),
              DataCell(Text(student.lastname2.toString())),
              DataCell(Text(student.email.toString())),
              DataCell(Text(student.phone.toString())),
              DataCell(Text(student.matricula.toString())),
              /*DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  dbHelper.delete(student.controlnum);
                  refreshList();
                },
              ))*/
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
            if (snapshot.data == null || snapshot.data.lengtgh == 0) {
              return Text("No data founded!");
            }
            return CircularProgressIndicator();
          }),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('INSERT DATA'),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            //list(),
          ],
        ),
      ),
    );
  }
  //Snackbar
  /*_showSnackBar(BuildContext, String texto) {
    final snackBar = SnackBar(
        content: new Text(texto)
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }*/
}

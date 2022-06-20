import 'package:flutter/material.dart'; //material design
import 'package:http/http.dart' as http; //agregar dependencia en pubspec.yaml
import 'dart:async'; //datos asincronos
import 'dart:convert'; //convertir data a json

void main() {
  runApp(
    MaterialApp(
      home: HomePage()
    ),
  );
}

class HomePage extends StatefulWidget {
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

//configurar disp. fisico en adb 
//adb reverse tcp:port tcp:port 
//adb reverse --list

  Map data = Map();
  List usersData = [];


  getUsers() async { //crear peticion http, async va despues de la funcion en dart
    http.Response response = await http.get(Uri.http('127.0.0.1:4000', '/api/users')); 
    data = json.decode(response.body); 
    setState(() { //Vuelve a actualizar los datos
      usersData = data['users'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //iniciar la app
    getUsers(); //apenas inicia ejecuta el metodo
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.indigo[900],
        ), 
        body: ListView.builder(
          itemCount: usersData == null ? 0 : usersData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0), 
                    child: Text(
                      "$index",
                       style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  CircleAvatar(backgroundImage: NetworkImage(usersData[index]['avatar']), //extraer imagenes
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "${usersData[index]["firstName"]} ${usersData[index]["lastName"]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700
                      ),
                    ), 
                  )
                ],
              ),
            );
          },
        
      ),
    );
  }
}
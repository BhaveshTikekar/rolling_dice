import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:todo/constructor.dart';
import 'package:todo/json.dart';

class TodoUi extends StatefulWidget {
  TodoUi({Key? key}) : super(key: key);

  @override
  _TodoUiState createState() => _TodoUiState();
}

class _TodoUiState extends State<TodoUi> {
  //late Future<Album> futureAlbum;
  bool waiting = true;
  @override
  void initState() {
    super.initState();
    this.fetchAlbum();
  }

  Future<List<Welcome>> fetchAlbum() async {
    final res = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (res.statusCode == 200) {
      List jsonres = jsonDecode(res.body);
      return jsonres.map((data) => new Welcome.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<List<Welcome>>(
            future: fetchAlbum(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Welcome> data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 50,
                        color: Colors.greenAccent[100],
                        shadowColor: Colors.black,
                        child: ListTile(
                          leading: FlutterLogo(),
                          title: Text(data[index].title),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

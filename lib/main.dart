import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:menfou/Search.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        title: 'Filmographia',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: myController,
              decoration: const InputDecoration(
                  labelText: 'Titre Film',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            ElevatedButton(
              onPressed: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new MySecondPage(value: myController.text));
                Navigator.of(context).push(route);
              },
              child: const Text('Enabled'),
            ),
          ],
        ),
      ),

// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MySecondPage extends StatefulWidget {
  MySecondPage({Key? key, required this.value}) : super(key: key);
  final String value;

  @override
  _MySecondPageState createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  final String url = 'http://www.omdbapi.com/?s=blade&apikey=49648e04';
  late Map<String, dynamic> film;
  bool dataOK = false;
  late int lengthTable;

  @override
  void initState() {
    recup();
    super.initState();
  }

  Future<void> recup() async {
    var response = await http.get(
        Uri.parse('http://www.omdbapi.com/?s=${widget.value}&apikey=49648e04'));
    if (response.statusCode == 200) {
      film = convert.jsonDecode(response.body);
      lengthTable = film['Search'].length;
      setState(() {
        dataOK = !dataOK;
      });
    }
  }

  Widget attente() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('En attente des données',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget affichage() {
    return Center(
        child: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: lengthTable,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: Image.network(film['Search'][index]['Poster']),
            title: Text('${film['Search'][index]['Title']}'),
            subtitle: Text('${film['Search'][index]['Year']}'),
            onTap: () {
              var route = MaterialPageRoute(
                  builder: (BuildContext context) => MyThirdPage(
                        valueID: film['Search'][index]['imdbID'],
                      ));
              Navigator.of(context).push(route);
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.value),
        backgroundColor: Colors.black38,
      ),
      body: dataOK ? affichage() : attente(),
      backgroundColor: Colors.blueGrey[900],
    );
  }
}

class MyThirdPage extends StatefulWidget {
  MyThirdPage({Key? key, required this.valueID}) : super(key: key);

  @override
  _MyThirdPage createState() => _MyThirdPage();
  final String valueID;
}

class _MyThirdPage extends State<MyThirdPage> {
  //variable
    late Map<String, dynamic> film;
  bool dataOK = false;

  @override
  void initState() {
    recupFilmID();
    super.initState();
  }

  Future<void> recupFilmID() async {
    var response = await http.get(Uri.parse(
        'http://www.omdbapi.com/?i=${widget.valueID}&apikey=49648e04'));
    if (response.statusCode == 200) {
      film = convert.jsonDecode(response.body);
      setState(() {
        dataOK = !dataOK;
      });
    }
  }

  Widget attente() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('En attente des données',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget affichage() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Text(
              '${film['Title']}',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
          Spacer(flex: 1),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(35, 57, 93, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child:
                          Image.network('${film['Poster']}',
                          width: 250,
                          height: 250,)
                      ),
                      Column(
                        children: [
                          Text('Titre: ${film['Title']}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text('Genre: ${film['Genre']}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            'Sortie: ${film['Year']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Acteur: ${film['Actors']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                )),
                          Text(''),
                          Text('Résumé: ${film['Plot']}',textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                              )),
                          Text(''),
                          Text('Note: ${film['imdbRating']}/10', textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${film['Title']}'),
        backgroundColor: Colors.black38,
      ),
      body: dataOK ? affichage() : attente(),
      backgroundColor: Colors.white24,
    );
  }
}

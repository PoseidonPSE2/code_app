import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;



   List<Widget> _widgetOptions = <Widget>[
    Text('Map Page'),
    Text('Refill Page'),
    Text('Profile Page'),
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _makeAPICall_get() async {
    final response =
        await http.get(Uri.parse('https://2sc10r.buildship.run/hello'));
    if (response.statusCode == 200) {
      // Handle successful API call
      print('API call successful');
      print(response.body);
    } else {
      // Handle error
      print('Failed to make API call');
    }
  }

  String _responseText = '';

  void _makeAPICall_post() async {
    Map<String, dynamic> data = {
      'water': 600, // Example value, replace with your actual data
      'user_id': 1, // Example value, replace with your actual data
      'water_type': 'sprudlig' // Example value, replace with your actual data
    };

    print("mooin");

    // Encode the data to JSON
    var body = json.encode(data);

    print("mooin2");

    // Make POST request
    final response = await http.post(
      Uri.parse('https://2sc10r.buildship.run/create_entry'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    print("mooin3");

    if (response.statusCode == 200) {
      // Handle successful API call
      setState(() {
        _responseText = response.body;
      });
    } else {
      // Handle error
      setState(() {
        _responseText = 'Failed to make API call';
      });
    }

    print(_responseText);
  }

  void _onItemTapped(int index) {
    setState(() {
      _counter = index;
      if (index == 1) {
        // Ersetzen Sie 1 durch den Index des "map"-Tabs in Ihrer Navbar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_counter),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Refill',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _counter,
        selectedItemColor: Colors.blue[300],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _makeAPICall_post,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'OAuth2 Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loggedIn = false;

  final String authorizationEndpoint = 'http://192.168.11.103:8080/realms/jhipster/protocol/openid-connect/token';
  String username = '';
  String password = '';
  final String identifier = 'prospace-mobile-client';
  final String secret = 'e6NTL8U1TueWyF7RH3DJsjPiNvY06nX0';
 // final String protectedResourceUrl = 'http://example.com/protected-resources.txt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("OAuth2 Example"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/space-1.jpg', // Chemin de l'image à partir du dossier "img"
            width: MediaQuery.of(context).size.width / 2, // Taille de l'image
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              padding: const EdgeInsets.all(10.0),
              onPressed: () => _login(),
              color: Colors.white,
              elevation: 5,
              child: const Text("Login with OAuth2"),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    try {
      var client = await oauth2.resourceOwnerPasswordGrant(
          Uri.parse(authorizationEndpoint), username, password,
          identifier: identifier, secret: secret);

      print('Access Token: ${client.credentials.accessToken}');

      if (client.credentials.accessToken.isNotEmpty) {
        setState(() {
          _loggedIn = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(),
          ),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed. Please check your credentials.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in successfully!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

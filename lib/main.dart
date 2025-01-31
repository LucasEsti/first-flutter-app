import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'screens/second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    developer.log('Application démarrée', name: 'MyApp');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

bool verifyPassword(String enteredPassword, String storedHash) {
  return hashPassword(enteredPassword) == storedHash;
}

final List<Map<String, String>> users = [
  {'email': 'test@example.com', 'password': hashPassword('password123')},
  {'email': 'user@example.com', 'password': hashPassword('securepass')},
];

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      final user = users.firstWhere(
        (user) => user['email'] == email && verifyPassword(password, user['password']!),
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        developer.log('Connexion réussie avec email: $email', name: 'LoginPage');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        developer.log('Échec de la connexion: email ou mot de passe incorrect', name: 'LoginPage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Email pré-enregistré: test@example.com"),
              Text("Mot de passe pré-enregistré: password123"),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CounterPage(),
    SecondPage(),
  ];

  void _onDestinationSelected(int index) {
    developer.log('Navigation vers la page: $index', name: 'MainScreen');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu")),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.countertops),
                selectedIcon: Icon(Icons.countertops, color: Colors.blue),
                label: Text('Compteur'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.edit),
                selectedIcon: Icon(Icons.edit, color: Colors.blue),
                label: Text('Formulaire'),
              ),
            ],
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    developer.log('Compteur incrémenté: $_counter', name: 'CounterPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Compteur Flutter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nombre de clics :"),
            Text("$_counter", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}
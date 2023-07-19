import 'package:espoch/vistas/inicioUserLogeado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? _email;
  String? _password;
  bool _isLoggedIn = false;

  void _showErrorNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future <void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        // Autenticación exitosa, navegar a la página de inicio
         setState(() {
      _isLoggedIn = true; // Actualizar el estado de inicio de sesión a true
    });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InicioLogeadoPage(),
          ),
        );
      } catch (e) {
        // Error de autenticación, mostrar notificación
        _showErrorNotification('Usuario o contraseña no válidos');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
     body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Usuario'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa el usuario';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa la contraseña';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
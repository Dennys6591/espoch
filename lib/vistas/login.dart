import 'package:espoch/vistas/inicioUserLogeado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingresar',
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
        backgroundColor: Color.fromARGB(255, 192, 30, 18),
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
        backgroundColor:Color.fromARGB(255, 202, 11, 11),
      ),
   body: SingleChildScrollView(
  child: Center(
    child: Padding(
      padding: EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.email)),
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
              decoration: InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.password_outlined),),
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
            SizedBox(height: 50.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 202, 11, 11),
              ),
              onPressed: _signInWithEmailAndPassword,
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    ),
  ),
),
    );
  }
}
import 'package:espoch/vistas/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:espoch/constantes.dart';
import 'package:espoch/vistas/inicioUserLogeado.dart';

import 'inicio.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  
   final bool isLoggedIn;

  const MyAppBar({required this.isLoggedIn, Key? key}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
  
    return AppBar(
      backgroundColor: color1,
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Flexible(flex: 1, child: Image.asset("assets/images/logo.png")),
      ),
      title: const Text('    L.E.A.R.N.S   ESPOCH'),
      actions: [
        Flexible(
          flex: 1,
          child: MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const InicioPage())));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Ajusta el radio de borde según sea necesario
            ),
            child: const Text('Inicio', style: TextStyle(color: Colors.white)),
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
            onPressed: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset buttonTopLeft =
                  button.localToGlobal(Offset.zero, ancestor: overlay);
              final Offset buttonBottomRight = button.localToGlobal(
                  button.size.bottomRight(Offset.zero),
                  ancestor: overlay);
              final double screenWidth = MediaQuery.of(context).size.width;
              final double dx = screenWidth; // Ajusta según sea necesario
              final Offset newTopLeft =
                  Offset(buttonTopLeft.dx + dx, buttonTopLeft.dy);
              final Offset newBottomRight =
                  Offset(buttonBottomRight.dx + dx, buttonBottomRight.dy);

              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(newTopLeft, newBottomRight),
                Offset.zero & overlay.size,
              );

              await showMenu(
                context: context,
                position: position,
                items: [
                  PopupMenuItem(
                    value: 1,
                    onTap: () {
                      // Lógica para manejar la selección de "Todos"
                    },
                    child: const Text('Todos'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      // Lógica para manejar la selección de "Informática y electrónica"
                    },
                    child: const Text('Informática y electrónica'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      // Lógica para manejar la selección de "Informática y electrónica"
                    },
                    child: const Text('Mecánica'),
                  ),
                  // Agrega más opciones de menú según tus necesidades
                ],
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Ajusta el radio de borde según sea necesario
            ),
            child: const Text('Recursos\ninstitucionales',
                style: TextStyle(fontSize: 9.0, color: Colors.white)),
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Ajusta el radio de borde según sea necesario
            ),
            child: const Text('Recursos\n abiertos',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      FloatingActionButton(
          onPressed: () {
            if (isLoggedIn) {
              // Cerrar sesión
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => InicioPage()),
                (Route<dynamic> route) => false,
              );
            } else {
              // Iniciar sesión
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
              );
            }
          },
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          elevation: 50.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLoggedIn ? Icons.logout : Icons.person_2_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(height: 4.0),
              Text(
                isLoggedIn ? 'Cerrar\nsesión' : 'Iniciar\nsesión',
                style: TextStyle(
                  fontSize: 9.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/////////////////// flooter

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      color: Colors.grey,
      child: const Padding(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Escuela Superior Politécnica de Chimborazo 2023\n',
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ),
              Text(
                '    Dirección: Panamericana sur km 1 1/2. Riobamba-Ecuador',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
              Text(
                '    Teléfono: 593(03) 2998-200',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
              Text(
                '    Telefax: (03)2317-001',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
              Text(
                '    Código Postal: EC060155',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

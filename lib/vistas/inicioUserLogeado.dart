import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espoch/vistas/repositorioLogeado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:espoch/vistas/crearRepositorio.dart';

import 'package:espoch/vistas/repositorio.dart';
import 'package:espoch/vistas/reutilizables.dart';

class InicioLogeadoPage extends StatefulWidget {
  const InicioLogeadoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InicioLogeadoPageState createState() => _InicioLogeadoPageState();
}

class _InicioLogeadoPageState extends State<InicioLogeadoPage> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<Widget> _pageItems = [];

  double containerHeight = 250.0;

  // Cantidad de recursos que deseas mostrar
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

///// se crean los repositorios aleatorios
 

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    } else {
      _pageController.jumpToPage(_pageItems.length - 1);
      setState(() {
        _currentPage = _pageItems.length - 1;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _pageItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _pageController.jumpToPage(0);
      setState(() {
        _currentPage = 0;
      });
    }
  }

  //////llamar contenedores
  Widget _buildPageItems() {
  final user = FirebaseAuth.instance.currentUser;
  final userID = user?.uid; // Obtener el ID del usuario autenticado

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('repositorios').where('usuario', isEqualTo: userID).snapshots(),
    builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.docs;
        List<Widget> page = [];

        for (var doc in data) {
          Map<String, dynamic> repoData = doc.data() as Map<String, dynamic>;
          String nombre = repoData['nombre'];
          String? urlImagen = repoData['urlImagen'];

          if (urlImagen != null) {
            page.add(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const repositoriosScreemLog(),
                    ),
                  );
                },
                child: Container(
  width: 500,
  height: 150,
  child: Center(
    child: SizedBox(
      width: 500,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300], // Puedes personalizar el color de fondo
          borderRadius: BorderRadius.circular(10.0), // Ajusta el radio de borde según sea necesario
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              urlImagen,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Icon(Icons.error);
              },
            ),
            const SizedBox(height: 8.0),
            AutoSizeText(
              nombre,
              style: const TextStyle(fontSize: 12.0, color: Colors.black),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  ),
),

                
              ),
            );
          }
        }

        return ListView(
          shrinkWrap: true,
         // physics: const NeverScrollableScrollPhysics(),
          children: page,
        );
      },
    );
  }
  ///
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(isLoggedIn: true,),
    body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Mis repositorios',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '   Buscar',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Color.fromARGB(255, 25, 182, 33),
              child: IconButton(
                onPressed: () {
                  // Lógica para manejar la acción del botón de búsqueda
                },
                icon: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          color: Color.fromARGB(255, 25, 182, 33),
          child: IconButton(
            onPressed: () {
              // Lógica para manejar la acción del botón "+"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearRepositorio()),
              );
            },
            icon: Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ////aqui se ponen los repositorios ahora esta solo creandose aleatoriamente pero deberia ir con una base de datos
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topLeft,
                ),
                const SizedBox(height: 5),
                _buildPageItems(),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),


      ////footer
      bottomNavigationBar: MyBottomNavigationBar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0), // Ajusta el espaciado aquí
            child: IconButton(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          IconButton(
            onPressed: _nextPage,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

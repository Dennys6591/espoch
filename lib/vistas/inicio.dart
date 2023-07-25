import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:espoch/vistas/repositorio.dart';
import 'package:espoch/vistas/reutilizables.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<Widget> _pageItems = [];

  double containerHeight = 250.0;

  // Modifica el tamaño de las imágenes aquí
  double imageWidth = 150.0;
  double imageHeight = 150.0;

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
    _buildPageItems();
    super.didChangeDependencies();
  }

  // Modifica la función _buildPageItems para obtener datos desde Firebase
  Widget _buildPageItems() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('repositorios').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }

      final data = snapshot.data!.docs;
      List<Widget> page = [];

      for (var doc in data) {
        Map<String, dynamic> repoData = doc.data() as Map<String, dynamic>;
        String id = repoData['id']; // Obtén el ID del documento
        String nombre = repoData['nombre'];
        String? urlImagen = repoData['urlImagen'];

        if (urlImagen != null) {
          page.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => repositoriosScreem(id), // Pasa el ID como parámetro
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
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(
        isLoggedIn: false,
      ),
      body: Padding(
  padding: const EdgeInsets.all(50.0),
  child: Column(
    children: <Widget>[
      const SizedBox(height: 10),
      const Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Recursos más populares',
          style: TextStyle(fontSize: 18),
        ),
      ),
      const SizedBox(height: 20),
      Expanded(
         // Envolver el contenedor en un Expanded para permitir que ocupe todo el espacio vertical disponible
        child: SingleChildScrollView(
          child: Container(
            child: AspectRatio(
              aspectRatio: 18 /22, // Proporción de aspecto deseada (puedes ajustarlo según tus necesidades)
              child: _buildPageItems(),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 173, 75,
                  75), // Puedes personalizar el color de fondo
              borderRadius: BorderRadius.circular(
                  8.0), // Ajusta el radio de la esquina según sea necesario
            ),
          ),
        ),
      ),
    ],
  ),
),

      bottomNavigationBar: MyBottomNavigationBar(),
      floatingActionButton: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}

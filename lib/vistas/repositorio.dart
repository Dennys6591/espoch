import 'package:flutter/material.dart';
import 'package:espoch/vistas/reutilizables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class repositoriosScreem extends StatefulWidget {
  final String id; // Recibe el ID como parámetro

  const repositoriosScreem(this.id, {Key? key}) : super(key: key);

  @override
  State<repositoriosScreem> createState() => _repositoriosState();
}

class _repositoriosState extends State<repositoriosScreem> {
  bool isVideosExpanded = false;
  bool isPresentacionesExpanded = false;
  bool isPDFExpanded = false;
  bool isOtrosExpanded = false;
  String nombreRecurso = '';
  String urlPDF = '';
  String urlRAR = '';
  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar los datos del repositorio según el ID
    loadRepositorioData();
  }

  void loadRepositorioData() async {
    try {
      // Realiza una consulta a Firestore para obtener los detalles del repositorio según el ID
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('repositorios')
          .doc(widget.id)
          .get();

      // Accede a los datos del documento y actualiza las variables locales
      Map<String, dynamic> repoData = document.data() as Map<String, dynamic>;
      nombreRecurso = repoData['nombre'];
      urlPDF = repoData['url_PDF'];
      urlRAR = repoData['url_RAR'];
      // Notifica a la interfaz gráfica que los datos han sido actualizados
      setState(() {});
    } catch (e) {
      print('Error al cargar los datos del repositorio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(isLoggedIn: false),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              nombreRecurso, // Muestra el nombre del recurso según el ID recibido
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
        
            GestureDetector(
              onTap: () {
                // Aquí manejas la expansión de la sección de PDF
                setState(() {
                  isPDFExpanded = !isPDFExpanded;
                });
              },
              child: Container(
                color: Color.fromARGB(255, 27, 155, 53),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      isPDFExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'PDF',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          if (isPDFExpanded)
  Container(
    padding: const EdgeInsets.all(8.0),
    color: Colors.grey,
    child: GestureDetector(
      onTap: () async {
        if (await canLaunch(urlPDF)) {
          await launch(urlPDF);
        } else {
          // Si no se puede abrir la URL, puedes mostrar un mensaje de error
          print('Error al abrir el PDF');
        }
      },
      child: Text(
        'Ver PDF',
        style: TextStyle(fontSize: 16),
      ),
    ),
  ),
            GestureDetector(
              onTap: () {
                // Aquí manejas la expansión de la sección de Otros
                setState(() {
                  isOtrosExpanded = !isOtrosExpanded;
                });
              },
              child: Container(
                color: Color.fromARGB(255, 27, 155, 53),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      isOtrosExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Otros',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            if (isOtrosExpanded)
             Container(
    padding: const EdgeInsets.all(8.0),
    color: Colors.grey,
    child: GestureDetector(
      onTap: () async {
        if (await canLaunch(urlRAR)) {
          await launch(urlRAR);
        } else {
          // Si no se puede abrir la URL, puedes mostrar un mensaje de error
          print('Error al abrir el RAR');
        }
      },
      child: Text(
        'Ver RAR',
        style: TextStyle(fontSize: 16),
      ),
    ),
  ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

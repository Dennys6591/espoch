import 'package:flutter/material.dart';
import 'package:espoch/vistas/reutilizables.dart';

class repositoriosScreem extends StatefulWidget {
  const repositoriosScreem({super.key});

  @override
  State<repositoriosScreem> createState() => _repositoriosState();
}

class _repositoriosState extends State<repositoriosScreem> {
bool isVideosExpanded = false;
  bool isPresentacionesExpanded = false;
  bool isPDFExpanded = false;
  bool isOtrosExpanded = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold (
    appBar: MyAppBar(),
    body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        
       children: [
         const SizedBox(height: 15),
        const Text("Nombre del recurso", style: TextStyle(fontSize: 18),),
         const SizedBox(height: 40),
      //////////////////////////barras desplegables con los recursos
         GestureDetector(
        onTap: () {
          setState(() {
            isVideosExpanded = !isVideosExpanded;
          });
        },
        child: Container(
          color: Color.fromARGB(255, 27, 155, 53),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                isVideosExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              const Text(
                'Videos',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      if (isVideosExpanded)
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey,
          child: const Column(
            children: [
              Text(
                'Video 1',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Video 2',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Video 3',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
       /////////////////////////
        GestureDetector(
        onTap: () {
          setState(() {
            isPresentacionesExpanded = !isPresentacionesExpanded;
          });
        },
        child: Container(
          color: Color.fromARGB(255, 27, 155, 53),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                isPresentacionesExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Presentaciones',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      if (isPresentacionesExpanded)
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey,
          child: Text(
            'Contenido adicional',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ///////////////////////////////
        GestureDetector(
        onTap: () {
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
                isPDFExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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
          child: Text(
            'Contenido adicional',
            style: TextStyle(fontSize: 16),
          ),
        ),
        //////////////////////
         GestureDetector(
        onTap: () {
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
                isOtrosExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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
          child: Text(
            'Contenido adicional',
            style: TextStyle(fontSize: 16),
          ),
        ),
    
        //////////////////////////////
        
       ],
      ),
    ),
    bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
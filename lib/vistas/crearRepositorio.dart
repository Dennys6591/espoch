import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'backend.dart';
import 'UpLoadLogic.dart';

class CrearRepositorio extends StatefulWidget {
  const CrearRepositorio({Key? key}) : super(key: key);

  @override
  State<CrearRepositorio> createState() => _CrearRepositorioState();
}

class _CrearRepositorioState extends State<CrearRepositorio> {
  bool isVideosExpanded = false;
  bool isObjetoExpanded = false;
  String _selectedOptionTipoRecurso = '';
  String _controllerNombreRecurso = '';
  List<String> objetosAprendizaje = ['Video 1', 'PDF 1', 'Objeto 1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Repositorio'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                "Información",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),

              //////////////////////////barras desplegables con los recursos
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre del recurso',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _controllerNombreRecurso = value;
                  });
                },
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  setState(() {
                    isVideosExpanded = !isVideosExpanded;
                    _selectedOptionTipoRecurso = 'Opción seleccionada';
                  });
                },
                child: Container(
                  color: Color.fromARGB(255, 27, 155, 53),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        isVideosExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedOptionTipoRecurso.isNotEmpty
                            ? _selectedOptionTipoRecurso
                            : 'Tipo de recurso',
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
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOptionTipoRecurso = 'Abierto';
                            isVideosExpanded = false;
                          });
                        },
                        child: Text(
                          'Abierto',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 1,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOptionTipoRecurso =
                                'Informática y electrónica';
                            isVideosExpanded = false;
                          });
                        },
                        child: Text(
                          'Informática y electrónica',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 1,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOptionTipoRecurso = 'Mecánica';
                            isVideosExpanded = false;
                          });
                        },
                        child: Text(
                          'Mecánica',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

              //////////////////////////////Imagen del recurso
              //////////////////// ingresar objetos de aprendizaje

              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: objetosAprendizaje.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(objetosAprendizaje[index]),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 27, 155, 53)),
                    ),
                    onPressed: () {
                      // Acción al hacer clic en el botón
                       Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubirPDF()),
              );
                    },
                    child: Text('Agregar objeto de aprendizaje'),
                  ),
                ],
              ),

              SizedBox(height: 20),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 27, 155, 53)),
                ),
                onPressed: () {
                  guardarNombreRepositorio(_controllerNombreRecurso, context);
                },
                child: Text('Guardar nombre del repositorio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

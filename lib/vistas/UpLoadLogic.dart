import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubirPDF extends StatefulWidget {
  @override
  _SubirPDF createState() => _SubirPDF();
}

class _SubirPDF extends State<SubirPDF> {
 TextEditingController _fileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subir recursos'),  backgroundColor:Color.fromARGB(255, 202, 11, 11),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 202, 11, 11),
              ),
              onPressed: Escoger_RAR,
              child: Text('Seleccionar archivo RAR'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 202, 11, 11),
              ),
              onPressed: Escoger_PDF,
              child: Text('Seleccionar PDF'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _fileNameController,
                decoration: InputDecoration(labelText: 'Nombre del archivo'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 202, 11, 11),
              ),
  onPressed: () {
    Subir_PDF(_fileNameController, context);
  },
  child: Text('Subir PDF'),
),


          ],
        ),
      ),
    );
  }

 
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class SubirPDF extends StatefulWidget {
  @override
  _SubirPDF createState() => _SubirPDF();
}

class _SubirPDF extends State<SubirPDF> {
  Uint8List? _pdfBytes;
  TextEditingController _fileNameController = TextEditingController();

  Future<void> Escoger_PDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfBytes = result.files.single.bytes;
      });
    } else {
      print('El usuario canceló la operación...');
    }
  }

  Future<void> Subir_PDF() async {
    if (_pdfBytes == null) {
      print('Ningún archivo seleccionado.');
      return;
    }

    String fileName = _fileNameController.text.trim();
    if (fileName.isEmpty) {
      print('Ingrese un nombre para el archivo.');
      return;
    }

    try {
      // Obtenemos la referencia al archivo en Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('pdfs').child(fileName + '.pdf');

      // Creamos un objeto SettableMetadata para especificar el tipo de contenido
      final metadata = SettableMetadata(contentType: 'application/pdf');

      // Subimos el archivo utilizando putData() y pasamos los bytes del PDF junto con la metadata
      await storageRef.putData(_pdfBytes!, metadata);

      print('Archivo subido con éxito.');
    } catch (e) {
      print('Error al subir el archivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subir PDF a Firebase Storage')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
              onPressed: Subir_PDF,
              child: Text('Subir PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

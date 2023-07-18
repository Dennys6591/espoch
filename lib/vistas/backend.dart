import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'UpLoadLogic.dart';

TextEditingController _fileNameController = TextEditingController();
SubirPDF ObjPdf = SubirPDF();
String urlPdf = '';
late var downloadURLpdf;
Uint8List? _pdfBytes;
var urlPDF = '';
////////////////Elegir un pfd////////////////
Future<void> Escoger_PDF() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    _pdfBytes = result.files.single.bytes;
  } else {
    print('El usuario canceló la operación...');
  }
}

////////////////Subir el pdf a storage////////////////
void Subir_PDF(
    TextEditingController nombre_archivo, BuildContext context) async {
  if (_pdfBytes == null) {
    print('Ningún archivo seleccionado.');
    //return;
  }

  String fileName = nombre_archivo.text.trim();
  if (fileName.isEmpty) {
    print('Ingrese un nombre para el archivo.');
    // return;
  }

  try {
    // Obtenemos la referencia al archivo en Firebase Storage
    final storageRef =
        FirebaseStorage.instance.ref().child('pdfs').child(fileName + '.pdf');

    // Creamos un objeto SettableMetadata para especificar el tipo de contenido
    final metadata = SettableMetadata(contentType: 'application/pdf');

    // Subimos el archivo utilizando putData() y pasamos los bytes del PDF junto con la metadata
    await storageRef.putData(_pdfBytes!, metadata);
    // Obtenemos la URL de descarga del archivo
    downloadURLpdf = await storageRef.getDownloadURL();
    print('URL de descarga del archivo: $downloadURLpdf');
    // await guardarURLenFirestore(fileName, downloadURLpdf);
    // url_PDF(downloadURLpdf); //
    print('Archivo subido con éxito.');
  } catch (e) {
    print('Error al subir el archivo: $e');
  }
}

////////////////////////////// subir nombre repositorio
Future<void> guardarNombreRepositorio(
    String nombreRepositorio, BuildContext context) async {
  if (nombreRepositorio.isNotEmpty) {
    // Guardar el nombre del repositorio en Firestore
    CollectionReference repositorios =
        FirebaseFirestore.instance.collection('repositorios');

    // Generar un nuevo ID en base al número de documentos existentes en la colección
    QuerySnapshot snapshot = await repositorios.get();
    int numDocumentos = snapshot.size;
    String nuevoID = 'repo${numDocumentos + 1}';

    // Verificar si el ID generado ya existe en la colección
    while (snapshot.docs.any((doc) => doc.id == nuevoID)) {
      numDocumentos++;
      nuevoID = 'repo${numDocumentos + 1}';
    }

    // Crear un nuevo documento con el nuevo ID generado
    DocumentReference newRepoRef = repositorios.doc(nuevoID);

    // Guardar el nombre del repositorio en el nuevo documento
    await newRepoRef.set({
      'nombre': nombreRepositorio,
    });

    print('Nombre del repositorio guardado en Firestore con ID: $nuevoID');

    // Subir la imagen y guardar la URL en Firestore

    Uint8List? imageBytes = await seleccionarImagen();
    if (imageBytes != null) {
      try {
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$nuevoID.jpg');

        final metadata = SettableMetadata(contentType: 'image/jpeg');

        // Subimos el archivo utilizando putData() y pasamos los bytes del PDF junto con la metadata
        await storageRef.putData(imageBytes, metadata);

        String downloadURL = await storageRef.getDownloadURL();

        await newRepoRef.set(
          {
            'urlImagen': downloadURL,
            'url_PDF': downloadURLpdf,
          },
          SetOptions(merge: true),
        );

        print('URL de la imagen guardado en Firestore');

        Navigator.pop(context);

        // Mostrar la imagen en una pantalla flotante
      showDialog(
  context: context,
  builder: (context) => AlertDialog(
    content: Image.memory(imageBytes),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cerrar'),
      ),
    ],
  ),
);
      } catch (e) {
        print('Error al subir la imagen: $e');
      }
    } else {
      print('No se seleccionó ninguna imagen');
    }
  } else {
    print('Por favor, ingresa el nombre del repositorio');
  }
}

////////////subir imagen
Future<Uint8List?> seleccionarImagen() async {
  final completer = Completer<Uint8List?>();

  html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    if (uploadInput.files!.isNotEmpty) {
      final reader = html.FileReader();
      reader.readAsDataUrl(uploadInput.files![0]);
      reader.onError.listen((error) => completer.completeError(error));
      reader.onLoad.first.then((_) {
        final encoded = reader.result as String;
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
        if (stripped.isNotEmpty) {
          completer.complete(Uint8List.fromList(base64.decode(stripped)));
        } else {
          completer.completeError('Error al leer la imagen');
        }
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}

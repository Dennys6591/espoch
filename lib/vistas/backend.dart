import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'UpLoadLogic.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_admin/firebase_admin.dart';

TextEditingController _fileNameController = TextEditingController();
SubirPDF ObjPdf = SubirPDF();
String urlPdf = '';
late var downloadURLpdf;
late var downloadURLrar;
Uint8List? _pdfBytes;
var urlPDF = '';
var _rarBytes;
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

/////////////////////////escoger rar
Future<void> Escoger_RAR() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['rar'],
  );

  if (result != null) {
    _rarBytes = result.files.single.bytes;
  } else {
    print('El usuario canceló la operación...');
  }
}
///////////////////////////////
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
    print('Archivo PDF subido con éxito.');

    // Subimos el archivo RAR
    final storageRefRAR =
        FirebaseStorage.instance.ref().child('rars').child(fileName + '.rar');
    await storageRefRAR.putData(_rarBytes!);
    // Obtenemos la URL de descarga del archivo RAR
    downloadURLrar = await storageRefRAR.getDownloadURL();
    print('URL de descarga del archivo RAR: $downloadURLrar');
    // Guardamos la URL en Firestore
  } catch (e) {
    print('Error al subir el archivo: $e');
  }
}

////////////////////////////// subir nombre tipo e imagen repositorio
Future<void> guardarNombreRepositorio(String nombreRepositorio,
    String tipoRepositorio, BuildContext context) async {
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
    final user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid; // Obtener el ID del usuario autenticado
    // Crear un nuevo documento con el nuevo ID generado
    DocumentReference newRepoRef = repositorios.doc(nuevoID);

    // Guardar el nombre del repositorio en el nuevo documento
    await newRepoRef.set({
      'id': nuevoID,
      'nombre': nombreRepositorio,
      'tipo': tipoRepositorio,
      'usuario': userID,
    });

    print(
        'Nombre y tipo del repositorio guardado en Firestore con ID: $nuevoID');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ingresar una imagen para el repositorio'),
          content: Text('Por favor, selecciona una imagen para continuar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );

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
            'url_RAR': downloadURLrar,
          },
          SetOptions(merge: true),
        );

        print('URL de la imagen guardado en Firestore');

        Navigator.pop(context);

        // Mostrar la imagen en una pantalla flotante
        // ignore: use_build_context_synchronously
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

  if (kIsWeb) {
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
  } else {
    // Dispositivo móvil
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      completer.complete(imageBytes);
    } else {
      completer.complete(null);
    }
  }

  return completer.future;
}

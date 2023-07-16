import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

        firebase_storage.UploadTask uploadTask =
            storageRef.putData(imageBytes);

        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() => null);

        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        await newRepoRef.set(
          {
            'urlImagen': downloadURL,
          },
          SetOptions(merge: true),
        );

        print('URL de la imagen guardado en Firestore');
        Navigator.pop(context);
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
  final picker = ImagePicker();
  XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    Uint8List? imageBytes = await pickedFile.readAsBytes();
    return imageBytes;
  }

  return null;
}
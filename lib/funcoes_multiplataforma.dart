import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

String pegaDispositivo() {
  if (kIsWeb) return "web";
  if (Platform.isAndroid) return "android";
  if (Platform.isIOS) return "ios";
  return "generico";
}

Future<XFile?> pegarImagemGaleria() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}

Future<XFile?> pegarImagemCamera() async {
  return await ImagePicker().pickImage(source: ImageSource.camera);
}

Future<XFile?> escolherImagem(BuildContext context) async {
  return await showModalBottomSheet<XFile?>(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Adicionar imagem"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final f = await pegarImagemGaleria();
              Navigator.pop(ctx, f);
            },
            child: const Row(
              children: [
                Icon(Icons.image_outlined, size: 28),
                SizedBox(width: 16),
                Text("Da galeria"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final f = await pegarImagemCamera();
              Navigator.pop(ctx, f);
            },
            child: const Row(
              children: [
                Icon(Icons.camera_alt_outlined, size: 28),
                SizedBox(width: 16),
                Text("Da câmera"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget mostrarImagem(XFile img, {double? altura}) {
  if (kIsWeb) {
    return Image.network(img.path, height: altura);
  } else {
    return Image.file(File(img.path), height: altura);
  }
}

//imagem para o Firebase
Future<String> uploadImagem(String caminho, XFile imagem) async {
  final storageRef = FirebaseStorage.instance.ref().child(caminho);

  if (kIsWeb) {
    // no web, pega bytes e usa putData
    final bytes = await imagem.readAsBytes();
    final snapshot = await storageRef.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await snapshot.ref.getDownloadURL();
  } else {
    // mobile usa File normalmente
    final file = File(imagem.path);
    final snapshot = await storageRef.putFile(file);
    return await snapshot.ref.getDownloadURL();
  }
}

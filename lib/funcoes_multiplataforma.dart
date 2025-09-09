  import 'dart:io' show File, Platform;
  import 'dart:typed_data';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'firebase_options.dart';

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
            Center(
              child: const Text("Infelizmente para adicionar imagens tem que pagar o Firebase, está função não estará disponivel até uma solução ser encontrada."),
            
            )
            /*ElevatedButton(
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
            ),*/
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
Future<String> uploadImagem(String caminho, XFile img) async {
  try {
    print("🔹 Iniciando upload para $caminho");

    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(caminho);

    if (kIsWeb) {
      print("🔹 Rodando no Web");
      final bytes = await img.readAsBytes();
      print("🔹 Lendo bytes (${bytes.length} bytes)");
      await ref.putData(bytes);
    } else {
      print("🔹 Rodando em Android/iOS");
      final file = File(img.path);
      print("🔹 Usando arquivo: ${file.path}");
      await ref.putFile(file);
    }

    final url = await ref.getDownloadURL();
    print("✅ Upload concluído. URL: $url");
    return url;
  } catch (e, st) {
    print("❌ Erro no uploadImagem: $e");
    print(st);
    rethrow;
  }
}

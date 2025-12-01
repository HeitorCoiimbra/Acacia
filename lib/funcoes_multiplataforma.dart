import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:uuid/uuid.dart';

final supabase = Supabase.instance.client;
final firestore = FirebaseFirestore.instance;

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
          //Center(
          //  child: const Text("Infelizmente para adicionar imagens tem que pagar o Firebase, está função não estará disponivel até uma solução ser encontrada."),
          //
          //)
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

Future<String?> uploadImagem(XFile image, {required String pasta}) async {
  try {
    // gera um nome único para o arquivo
    final filename = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    final path = '$pasta/$filename';

    // lê os bytes da imagem
    final Uint8List bytes = await image.readAsBytes();

    // faz upload para o bucket com o path especificado
    await Supabase.instance.client.storage
        .from('imagens') // nome do bucket
        .uploadBinary(path, bytes);

    // pega a URL pública
    final publicUrl = Supabase.instance.client.storage
        .from('imagens')
        .getPublicUrl(path);

    print('🟢 Upload concluído em $path');
    print('🔵 URL recebida: $publicUrl');

    return publicUrl;
  } catch (e) {
    print('🔴 Erro ao enviar imagem: $e');
    return null;
  }
}


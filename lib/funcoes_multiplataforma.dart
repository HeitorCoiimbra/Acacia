import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pegarImagemGaleria() async {
  final img = await ImagePicker().pickImage(source: ImageSource.gallery);
  return img; 
}

Future<XFile?> pegarImagemCamera() async {
  final img = await ImagePicker().pickImage(source: ImageSource.camera);
  return img;
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

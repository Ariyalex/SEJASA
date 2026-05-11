import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ProjectDescriptionEditor extends HookWidget {
  final QuillController controller;

  const ProjectDescriptionEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi Project',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: controller,

                config: const QuillSimpleToolbarConfig(showSearchButton: false),
              ),
              const Divider(height: 1),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuillEditor.basic(
                    controller: controller,
                    config: const QuillEditorConfig(
                      placeholder: 'Masukkan deskripsi project...',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

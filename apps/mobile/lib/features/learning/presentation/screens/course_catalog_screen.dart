
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseCatalogScreen extends ConsumerWidget {
  const CourseCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('CourseCatalogScreen')),
      body: const Center(child: Text('CourseCatalogScreen UI goes here')),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CertificateViewScreen extends ConsumerWidget {
  const CertificateViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('CertificateViewScreen')),
      body: const Center(child: Text('CertificateViewScreen UI goes here')),
    );
  }
}


import 'package:flutter/material.dart';

class StudyMasterMainMenuScreen extends StatelessWidget {
  const StudyMasterMainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Master Main Menu'),
      ),
      body: const Center(
        child: Text('Welcome to Study Master!'),
      ),
    );
  }
}

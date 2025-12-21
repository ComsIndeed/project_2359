import 'package:flutter/material.dart';

class StudySession extends StatefulWidget {
  const StudySession({super.key});

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study'), elevation: 0),
      body: const Center(child: Text('Study Session')),
    );
  }
}

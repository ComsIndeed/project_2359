import 'package:flutter/material.dart';

class NoteTakingPage extends StatelessWidget {
  final String collectionId;
  final String? deckId;
  final String? draftId;

  const NoteTakingPage({
    super.key,
    required this.collectionId,
    this.deckId,
    this.draftId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Taking Page (Placeholder)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Collection ID: $collectionId'),
            if (deckId != null) Text('Deck ID: $deckId'),
            if (draftId != null) Text('Draft ID: $draftId'),
            const SizedBox(height: 20),
            const Text('This is a placeholder for the Note Taking features.'),
          ],
        ),
      ),
    );
  }
}

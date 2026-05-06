import 'package:flutter/foundation.dart';
import 'package:fsrs/fsrs.dart' as fsrs_dart;
import 'package:fsrs_rs/fsrs.dart' as fsrs_rs;

// Shim for old fsrs package types to allow compilation after switching to fsrs-rs-dart
enum FsrsRating { again, hard, good, easy }
enum FsrsState { new_, learning, review, relearning }

class Card {
  final int cardId;
  final DateTime due;
  final double stability;
  final double difficulty;
  final FsrsState state;
  final int step;
  final DateTime? lastReview;
  Card({
    required this.cardId,
    required this.due,
    required this.stability,
    required this.difficulty,
    required this.state,
    required this.step,
    this.lastReview,
  });

  // Convert to pure Dart FSRS card
  fsrs_dart.Card toDartCard() {
    return fsrs_dart.Card()
      ..due = due
      ..stability = stability
      ..difficulty = difficulty
      ..state = fsrs_dart.State.values[state.index]
      ..step = step
      ..lastReview = lastReview;
  }

  // From pure Dart FSRS card
  factory Card.fromDartCard(int cardId, fsrs_dart.Card dartCard) {
    return Card(
      cardId: cardId,
      due: dartCard.due,
      stability: dartCard.stability!,
      difficulty: dartCard.difficulty!,
      state: FsrsState.values[dartCard.state.index],
      step: dartCard.step!,
      lastReview: dartCard.lastReview,
    );
  }
}

class Scheduler {
  final fsrs_dart.FSRS _dartFsrs = fsrs_dart.FSRS();
  
  CardResult reviewCard(Card card, FsrsRating rating) {
    final now = DateTime.now();

    if (kIsWeb) {
      // Use pure Dart implementation
      final dartCard = card.toDartCard();
      final schedulingInfo = _dartFsrs.repeat(dartCard, now);
      
      // Get the specific rating result
      fsrs_dart.Card resultCard;
      switch (rating) {
        case FsrsRating.again:
          resultCard = schedulingInfo[fsrs_dart.Rating.again]!.card;
          break;
        case FsrsRating.hard:
          resultCard = schedulingInfo[fsrs_dart.Rating.hard]!.card;
          break;
        case FsrsRating.good:
          resultCard = schedulingInfo[fsrs_dart.Rating.good]!.card;
          break;
        case FsrsRating.easy:
          resultCard = schedulingInfo[fsrs_dart.Rating.easy]!.card;
          break;
      }
      return CardResult(card: Card.fromDartCard(card.cardId, resultCard));
    } else {
      // Use Rust implementation
      final rustFsrs = fsrs_rs.Fsrs(parameters: fsrs_rs.defaultParameters());
      
      final daysElapsed = card.lastReview != null 
          ? now.difference(card.lastReview!).inDays 
          : 0;
          
      final currentMemoryState = fsrs_rs.MemoryState(
        stability: card.stability,
        difficulty: card.difficulty,
      );
      
      final nextStates = rustFsrs.nextStates(
        currentMemoryState: currentMemoryState,
        desiredRetention: 0.9, 
        daysElapsed: daysElapsed,
      );
      
      fsrs_rs.ItemState resultState;
      switch (rating) {
        case FsrsRating.again:
          resultState = nextStates.again;
          break;
        case FsrsRating.hard:
          resultState = nextStates.hard;
          break;
        case FsrsRating.good:
          resultState = nextStates.good;
          break;
        case FsrsRating.easy:
          resultState = nextStates.easy;
          break;
      }
      
      return CardResult(card: Card(
        cardId: card.cardId,
        due: now.add(Duration(days: resultState.interval.round())),
        stability: resultState.memory.stability,
        difficulty: resultState.memory.difficulty,
        state: card.state, // Rust implementation doesn't return state enum directly yet
        step: card.step,
        lastReview: now,
      ));
    }
  }
}

class CardResult {
  final Card card;
  CardResult({required this.card});
}

import 'dart:math' as math;
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:project_2359/app_database.dart';

class ContinuousSessionController {
  final List<CardItem> _queue;
  final Map<String, int> _lapseCount = {};
  int _totalReviews = 0;

  ContinuousSessionController(List<CardItem> cards) : _queue = _sortCards(cards);

  /// Initial sorting by retention (R = e^(-t/S)).
  static List<CardItem> _sortCards(List<CardItem> cards) {
    final now = DateTime.now();
    final List<CardItem> sorted = List.from(cards);
    
    sorted.sort((a, b) {
      final rA = _calculateRetention(a, now);
      final rB = _calculateRetention(b, now);
      return rA.compareTo(rB);
    });
    
    return sorted;
  }

  /// Calculates the retention for a card based on its spaced repetition stats.
  static double _calculateRetention(CardItem card, DateTime now) {
    if (card.spacedLastReview == null) return -1.0; // New cards first
    
    final t = now.difference(card.spacedLastReview!).inSeconds / (24 * 3600);
    final s = card.spacedStability ?? 0.0;
    
    if (s <= 0) return 0.0;
    
    // R = 0.9 ^ (t / S)
    return math.pow(0.9, t / s).toDouble();
  }

  CardItem? get nextCard => _queue.isNotEmpty ? _queue.first : null;
  
  int get queueLength => _queue.length;
  int get totalReviews => _totalReviews;

  /// Process user rating for the current card.
  void submitRating(fsrs.Rating rating) {
    if (_queue.isEmpty) return;
    
    final card = _queue.removeAt(0);
    _totalReviews++;

    if (rating == fsrs.Rating.again) {
      _lapseCount[card.id] = (_lapseCount[card.id] ?? 0) + 1;
      
      // Reinsert 5-10 positions ahead (clamped to queue length)
      final reinsertPos = math.min(_queue.length, 5 + math.Random().nextInt(6));
      _queue.insert(reinsertPos, card);
    } else {
      // Correct answer: send to the back of the queue
      _queue.add(card);
    }
  }

  /// Returns a map of card IDs to the number of times they were missed in this session.
  Map<String, int> getSessionRelapses() => Map.unmodifiable(_lapseCount);
  
  bool get isEmpty => _queue.isEmpty;
}

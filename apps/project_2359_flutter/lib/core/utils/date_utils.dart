class DateUtils {
  static String formatFsrsInterval(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours;
    final minutes = duration.inMinutes;

    if (minutes < 60) {
      return 'In ${minutes}m';
    }

    if (hours < 24) {
      return 'In ${hours}h';
    }

    if (days < 365) {
      return 'In ${days}d';
    }

    final years = (days / 365).toStringAsFixed(1);
    return 'In ${years}y';
  }

  static String formatNextDueDate(DateTime nextDue) {
    final now = DateTime.now();
    final duration = nextDue.difference(now);

    if (duration.isNegative) {
      return 'Review now';
    }

    return 'Next due: ${formatFsrsInterval(duration)}';
  }

  static bool isOverdue(DateTime nextDue) {
    return nextDue.isBefore(DateTime.now());
  }
}

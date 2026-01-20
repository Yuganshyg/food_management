class FeedbackItem {
  final int rating;
  final String comment;
  final String date;

  FeedbackItem({
    required this.rating,
    required this.comment,
    required this.date,
  });

  // ───────── FROM JSON ─────────
  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
    );
  }

  // ───────── TO JSON (FIX) ─────────
  Map<String, dynamic> toJson() {
    return {'rating': rating, 'comment': comment, 'date': date};
  }
}

class FeedbackItem {
  final int rating;
  final String comment;
  final String date;

  FeedbackItem({
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'rating': rating, 'comment': comment, 'date': date};
  }
}

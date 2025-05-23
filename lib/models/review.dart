class TrustReview {
  final String id;
  final String reviewerId;
  final String reviewedUserId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? bookingId;

  TrustReview({
    required this.id,
    required this.reviewerId,
    required this.reviewedUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.bookingId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewerId': reviewerId,
      'reviewedUserId': reviewedUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'bookingId': bookingId,
    };
  }

  static TrustReview fromMap(Map<String, dynamic> map) {
    return TrustReview(
      id: map['id'],
      reviewerId: map['reviewerId'],
      reviewedUserId: map['reviewedUserId'],
      rating: map['rating'],
      comment: map['comment'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}

class TaskReview {
  final String id;
  final String requestId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  TaskReview({
    required this.id,
    required this.requestId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  static TaskReview fromMap(Map<String, dynamic> map) {
    return TaskReview(
      id: map['id'],
      requestId: map['requestId'],
      rating: map['rating'],
      comment: map['comment'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}
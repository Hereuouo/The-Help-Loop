class Tracking {
  final String id;
  final String requestId;
  final String updatedStatus;
  final DateTime timestamp;

  Tracking({
    required this.id,
    required this.requestId,
    required this.updatedStatus,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'updatedStatus': updatedStatus,
      'timestamp': timestamp,
    };
  }

  static Tracking fromMap(Map<String, dynamic> map) {
    return Tracking(
      id: map['id'],
      requestId: map['requestId'],
      updatedStatus: map['updatedStatus'],
      timestamp: map['timestamp'].toDate(),
    );
  }
}
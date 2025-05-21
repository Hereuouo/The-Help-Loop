class Request {
  final String id;
  final String userId;
  final String skillId;
  final String exchangeType;
  final String status;

  Request({
    required this.id,
    required this.userId,
    required this.skillId,
    required this.exchangeType,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'skillId': skillId,
      'exchangeType': exchangeType,
      'status': status,
    };
  }

  static Request fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      userId: map['userId'],
      skillId: map['skillId'],
      exchangeType: map['exchangeType'],
      status: map['status'],
    );
  }
}
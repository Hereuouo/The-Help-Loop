class Booking {
  final String id;
  final String requestId;
  final DateTime bookedTime;
  final bool confirmed;

  Booking({
    required this.id,
    required this.requestId,
    required this.bookedTime,
    required this.confirmed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'bookedTime': bookedTime,
      'confirmed': confirmed,
    };
  }

  static Booking fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      requestId: map['requestId'],
      bookedTime: map['bookedTime'].toDate(),
      confirmed: map['confirmed'],
    );
  }
}
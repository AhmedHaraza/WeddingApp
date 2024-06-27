class Reservation {
  final DateTime dateTime;
  final String photographerId;
  final String photographerName;
  final String photographerPhone;
  final String userId;
  final String userName;
  final String userPhone;

  Reservation({
    required this.dateTime,
    required this.photographerId,
    required this.photographerName,
    required this.photographerPhone,
    required this.userId,
    required this.userName,
    required this.userPhone,
  });
}
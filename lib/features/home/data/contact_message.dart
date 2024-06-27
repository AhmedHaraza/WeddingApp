class ContactMessage {
  final String name;
  final String email;
  final String subject;
  final String message;
  late final String time;

  ContactMessage(
    this.name,
    this.email,
    this.subject,
    this.message,
  );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'time': time,
    };
  }
}

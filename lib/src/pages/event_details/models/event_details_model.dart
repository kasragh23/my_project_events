class EventDetailsModel {
  int id;
  int userId;
  String? poster;
  final String title;
  final String description;
  DateTime? date;
  int capacity;
  int? attendance;
  final int price;

  EventDetailsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.capacity,
    this.poster,
    this.date,
    this.attendance,
  });

  factory EventDetailsModel.fromJson(final Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['date']);
    return EventDetailsModel(
      id: json['id'],
      userId: json['userId'],
      poster: json['poster'],
      title: json['title'],
      description: json['description'],
      date: date,
      capacity: json['capacity'],
      attendance: json['attendance'] ?? 0,
      price: json['price'],
    );
  }
}

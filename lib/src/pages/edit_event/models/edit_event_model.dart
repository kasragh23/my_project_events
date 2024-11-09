class EditEventModel {
  int id;
  int userId;
  String? poster;
  final String title;
  final String description;
  DateTime? date;
  int capacity;
  int? attendance;
  final int price;

  EditEventModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    this.poster,
    this.date,
    required this.capacity,
    this.attendance,
  });

  factory EditEventModel.fromJson(final Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['date']);
    return EditEventModel(
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
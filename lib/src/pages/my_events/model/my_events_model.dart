class MyEventsModel {
  int? id;
  int? userId;
  String? poster;
  final String title;
  final String description;
  DateTime? date;
  int? capacity;
  int? attendance;
  final int price;

  MyEventsModel({
    this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.price,
    this.poster,
    this.date,
    this.capacity,
    this.attendance,
  });

  factory MyEventsModel.fromJson(final Map<String, dynamic> json) {
    DateTime date= DateTime.parse(json['date']);
    return MyEventsModel(
      id: json['id'],
        userId: json['userId'],
        title: json['title'],
        poster: json['poster'],
        description: json['description'],
        date: date,
        capacity: json['capacity'],
        attendance: json['attendance'] ?? 0,
        price: json['price'],
      );
  }

}

class AddEventModel {
  int? id;
  int? userId;
  String? poster;
  final String title;
  final String description;
  DateTime? date;
  int? capacity;
  int? attendance;
  final int price;

  AddEventModel({
    required this.title,
    required this.description,
    required this.price,
    this.poster,
    this.date,
    this.capacity,
    this.attendance,
  });

  factory AddEventModel.fromJson(final Map<String, dynamic> json) =>
      AddEventModel(
        title: json['title'],
        poster: json['poster'],
        description: json['description'],
        date: json['date'],
        capacity: json['capacity'],
        attendance: json['attendance'] ?? 0,
        price: json['price'],
      );
}

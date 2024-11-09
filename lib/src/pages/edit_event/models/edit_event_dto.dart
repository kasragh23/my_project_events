class EditEventDto {
  int? id;
  int? userId;
  String? poster;
  final String title;
  final String description;
  final String date;
  final int price;
  int capacity;
  int? attendance;

  EditEventDto({
    this.id,
    this.userId,
    this.poster,
    required this.title,
    required this.description,
    required this.price,
    required this.date,
    required this.capacity,
    this.attendance,
  });

  Map<String, dynamic> toJson() => {
    'poster': poster,
    'title': title,
    'description': description,
    'price': price,
    'date': date,
    'capacity': capacity
  };
}

class AddEventDto {
  int? id;
  int userId;
  final String poster;
  final String title;
  final String description;
  final String date;
  final int capacity;
  int? attendance = 0;
  final int price;

  AddEventDto({
    required this.userId,
    required this.poster,
    required this.title,
    required this.description,
    required this.date,
    required this.capacity,
    required this.price,
    this.attendance,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'poster': poster,
        'title': title,
        'description': description,
        'date': date,
        'capacity': capacity,
        'attendance': attendance ?? 0,
        'price': price,
      };
}

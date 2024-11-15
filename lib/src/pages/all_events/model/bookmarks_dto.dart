class BookmarksDto {
  int? id;
  final int userId;
  List? bookedEvents;

  BookmarksDto({
    this.id,
    required this.userId,
    required this.bookedEvents,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'bookedEvents': bookedEvents,
  };
}
class EventDetailDto {
  final int attendance;

  EventDetailDto({required this.attendance});

  Map<String, dynamic> toJson()=>{
    'attendance': attendance
  };
}
class RepositoryUrls {
  RepositoryUrls._();

  static const String _baseUrl = 'localhost:3000';
  static const String _users = '/users';
  static const String _allEvents = '/allEvents';
  static const String _bookmarks = '/bookmarks';

  static Uri getDatabase = Uri.http(_baseUrl);

  static Uri getUsers = Uri.http(_baseUrl, _users);

  static Uri registerUser = Uri.http(_baseUrl, _users);

  static Uri getAllEvents = Uri.http(_baseUrl,_allEvents);

  static Uri addEvent = Uri.http(_baseUrl, _allEvents);


  static Uri createBookmark = Uri.http(_baseUrl, _bookmarks);

  static Uri getBookmarksByUserId(userId) => Uri.parse('http://$_baseUrl$_bookmarks?userId=$userId');

  static Uri getBookedEvents(String param) => Uri.parse('http://$_baseUrl$_allEvents?$param');

  static Uri removeBookmark(id) => Uri.parse('http://$_baseUrl$_bookmarks/$id');

  static Uri addBookmark(id) => Uri.parse('http://$_baseUrl$_bookmarks/$id');

  static Uri getUserById({required int id}) => Uri.http(_baseUrl,'$_users/$id');

  static Uri getEventById({required int id}) => Uri.http(_baseUrl,'$_allEvents/$id');

  static Uri deleteEventById({required int id}) => Uri.http(_baseUrl,'$_allEvents/$id');

  static Uri editEventById({required int id}) => Uri.http(_baseUrl,'$_allEvents/$id');


  static Uri getEventsByUserId({required int id}) => Uri.parse('http://$_baseUrl$_allEvents?userId=$id');

}
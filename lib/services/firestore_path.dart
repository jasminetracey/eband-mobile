class FirestorePath {
  static String user(String uid) => 'users/$uid';

  static String event(String eventId) => 'events/$eventId';
  static String events() => 'events';
}

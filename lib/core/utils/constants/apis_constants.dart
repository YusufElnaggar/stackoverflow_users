class APIsConstants {
  // users
  static String get usersRequest => '/users';

  // reputations
  static String getReputationsRequest(int userId) =>
      '/users/$userId/reputation-history';
}

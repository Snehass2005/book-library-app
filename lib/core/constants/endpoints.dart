class ApiEndpoint {
  static const String login = 'auth/login';
  static const String deleteBook = 'library/delete-book';
  static const String apiKey = 'AIzaSyBr2ij0xweJ2k1DmN5-OvhJ4NMR6T5I_mw';
  static const String books = '/volumes?q=flutter&key=$apiKey';
  static String bookDetails(String bookId) => '/books/$bookId';
  static const String addBook = '/books/add';
  static String bookRecommendations(String bookId) => '/books/$bookId/recommendations';
  static String bookReviews(String bookId) => '/books/$bookId/reviews';
  static String bookRatings(String bookId) => '/books/$bookId/ratings';
  static String searchBooks(String query) => '/volumes?q=$query&key=$apiKey';
  static String submitProgress(String bookId) => '/books/$bookId/progress';
  static String getProgress(String bookId, String userId) => '/books/$bookId/progress?userId=$userId';
}

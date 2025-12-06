class ApiEndpoint {
  // --- Google Books API -------------------------
  static const String googleApiKey = 'AIzaSyBYKGCB3khC3J08OHLSoytC2_JeXh4QuQw';

  static String searchBooks(String query) =>
      'https://www.googleapis.com/books/v1/volumes?q=$query&key=$googleApiKey';

  // ✅ Alias for compatibility with DataSource
  static String getGoogleBooksUrl(String query) =>
      searchBooks(query);

  static String bookDetails(String bookId) =>
      'https://www.googleapis.com/books/v1/volumes/$bookId?key=$googleApiKey';

  // --- Local API -------------------------
  static const String login = 'auth/login';
  static const String addBook = 'books/add';
  static const String deleteBook = 'library/delete-book';
  static String bookRecommendations(String bookId) => 'books/$bookId/recommendations';
  static String bookReviews(String bookId) => 'books/$bookId/reviews';
  static String bookRatings(String bookId) => 'books/$bookId/ratings';
  static String submitProgress(String bookId) => 'books/$bookId/progress';
  static String getProgress(String bookId, String userId) => 'books/$bookId/progress?userId=$userId';
}
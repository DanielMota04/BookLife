class Routes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';

  static const library = '/library';
  static const addBook = '/library/add';

  static const settings = '/settings';
  static const editProfile = '/settings/profile';
  static const changePassword = '/settings/change-password';
  static const about = '/settings/about';
  static const themes = '/settings/themes';

  static String bookDetailsOf(String bookId) => '/library/$bookId';
  static String editBookOf(String bookId) => '/library/$bookId/edit';
  static String collectionDetailsOf(String collectionId) =>
      '/collections/$collectionId';
}

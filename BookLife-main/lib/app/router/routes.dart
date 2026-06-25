class Routes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';

  static const library = '/library';
  static const addBook = '/library/add';

  static const progress = '/progress';
  static const goals = '/goals';

  static const settings = '/settings';
  static const editProfile = '/settings/edit-profile';
  static const changePassword = '/settings/change-password';
  static const about = '/settings/about';
  static const themes = '/settings/themes';
  static const profile = '/settings/profile';

  static String bookDetailsOf(String book) => '/library/$book';
  static String editBookOf(String bookId) => '/library/$bookId/edit';
  static String collectionDetailsOf(String collectionId) =>
      '/collections/$collectionId';
}

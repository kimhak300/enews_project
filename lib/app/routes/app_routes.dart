part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const HOME = _Paths.HOME;
  static const CATEGORY = _Paths.CATEGORY;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const SEARCH = _Paths.SEARCH;
  static const BOOKMARK = _Paths.BOOKMARK;
  static const PROFILE = _Paths.PROFILE;
  static const SETTINGS = _Paths.SETTINGS;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const ABOUT = _Paths.ABOUT;
  static const BOTTOM_NAV = _Paths.BOTTOM_NAV;
  static const EDIT_POST = _Paths.EDIT_POST;
  static const EDIT_VIDEO = _Paths.EDIT_VIDEO;
  static const EDIT_ARTICLE = _Paths.EDIT_ARTICLE;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const NOTIFICATIONS = '/notifications';
  static const HOME = '/home';
  static const CATEGORY = '/category';
  static const DASHBOARD = '/dashboard';
  static const SEARCH = '/search';
  static const BOOKMARK = '/bookmark';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const BOTTOM_NAV = '/bottomNav';
  static const ABOUT = '/about';
  static const EDIT_POST = '/edit-post';
  static const EDIT_VIDEO = '/edit-video';
  static const EDIT_ARTICLE = '/edit-article';
}

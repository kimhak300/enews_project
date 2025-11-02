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
  static const ARTICLE_LIST = _Paths.ARTICLE_LIST;
  static const ARTICLE_DETAIL = _Paths.ARTICLE_DETAIL;
  static const SEARCH = _Paths.SEARCH;
  static const BOOKMARK = _Paths.BOOKMARK;
  static const PROFILE = _Paths.PROFILE;
  static const SETTINGS = _Paths.SETTINGS;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const ABOUT = _Paths.ABOUT;
  static const BOTTOM_NAV = _Paths.BOTTOM_NAV;
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
  static const ARTICLE_LIST = '/article-list';
  static const ARTICLE_DETAIL = '/article-detail';
  static const SEARCH = '/search';
  static const BOOKMARK = '/bookmark';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const BOTTOM_NAV = '/bottomNav';
  static const ABOUT = '/about';
}



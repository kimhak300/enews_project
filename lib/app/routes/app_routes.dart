abstract class Routes {

  /// Auth
  static const SPLASH = '/SPLASH';
  static const LOGIN = '/LOGIN';
  static const REGISTER = '/REGISTER';
  static const FORGOT_PASSWORD = '/FORGOT_PASSWORD';

  /// Admin
  static const ADMIN_BOTTOM_NAV = '/ADMIN_BOTTOM_NAV';
  static const ADMIN_DASHBOARD = '/ADMIN_DASHBOARD';
  static const ADMIN_MANAGE_ARTICLE = '/ADMIN_MANAGE_ARTICLE';
  static const ADMIN_MANAGE_CATEGORY = '/ADMIN_MANAGE_CATEGORY';
  static const ADMIN_MANAGE_USER = '/ADMIN_MANAGE_USER';
  static const ADMIN_USER_DETAIL = '/ADMIN_USER_DETAIL';
  static const ADMIN_ANALYTICS = '/ADMIN_ANALYTICS';
  static const ADMIN_MANAGER_PROFILE = '/ADMIN_MANAGE_PROFILE';

  /// USer
  static const USER_BOTTOM_NAV = '/USER_BOTTOM_NAV';
  static const USER_HOME = '/USER_HOME';
  static const USER_BOOKMARK = '/USER_BOOKMARK';
  static const USER_SEARCH = '/USER_SEARCH';
  static const USER_PROFILE = '/USER_PROFILE';

  /// Organization
  static const ORG_BOTTOM_NAV = '/ORG_BOTTOM_NAV';
  static const ORG_HOME = '/ORG_HOME';
  static const ORG_MANAGE_ARTICLE = '/USER_MANAGE_ARTICLE';
  static const ORG_TEAM = '/USER_TEAM';
  static const ORG_REPORT = '/USER_REPORT';
  static const ORG_PROFILE = '/USER_PROFILE';

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

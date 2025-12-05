import 'package:newshub/modules/admin/admin_pages.dart';
import 'package:newshub/modules/auth/auth_pages.dart';
import 'package:newshub/modules/organization/org_pages.dart';
import 'package:newshub/modules/user/user_pages.dart';

class AppPages {

  static final pages = [
    ...AdminPages.pages,
    ...UserPages.pages,
    ...OrgPages.pages,
    ...AuthPages.pages
  ];

}
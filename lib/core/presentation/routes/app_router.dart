import 'package:auto_route/annotations.dart';
import 'package:bootcamp_project_02/auth/presentation/authorization_page.dart';
import 'package:bootcamp_project_02/auth/presentation/sign_in_page.dart';
import 'package:bootcamp_project_02/github/repos/starred_repos/presentation/starred_repos_page.dart';
import 'package:bootcamp_project_02/splash/presentation/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage, path: '/sign-in'),
    MaterialRoute(page: AuthorizationPage, path: '/auth'),
    MaterialRoute(page: StarredRepoPage, path: '/starred'),
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}

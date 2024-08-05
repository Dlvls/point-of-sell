import 'package:go_router/go_router.dart';
import 'package:point_of_sell/auth/welcome_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/welcome_page',
    routes: [
      GoRoute(
        path: '/welcome_page',
        builder: (context, state) => const WelcomePage(),
      ),
    ],
  );
}

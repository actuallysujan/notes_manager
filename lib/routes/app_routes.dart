import 'package:flutter/material.dart';
import 'package:notes_manager/views/auth/signup_view.dart';
import '../views/auth/login_view.dart';
import '../views/dashboard/dashboard_view.dart';

class AppRoutes {
  static const login = '/login';

  static const signup = '/signup';
  static const dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginView(),
    signup: (_) => const SignupView(),
    dashboard: (_) => const DashboardView(),
  };
}

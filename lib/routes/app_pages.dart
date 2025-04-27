import 'package:get/get.dart';
import 'package:personal_ai_assistant/views/auth/login_screen.dart';
import 'package:personal_ai_assistant/views/auth/signup_screen.dart';
import '../views/home/daily_planner.dart';
import '../views/home/dashboard_view.dart';
import '../views/home/task_view.dart';



 final pages = [
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/signup', page: () => SignUpScreen()),
          GetPage(name: '/home', page: () => DashboardView()), 
          GetPage(name: '/taskView', page: () => TaskCreationPage()), 
          GetPage(name: '/dailyplanner', page: () => DailyPlannerScreen()),
        ];

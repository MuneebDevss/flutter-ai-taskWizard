
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/Auth/Presentation/AuthBloc/auth_bloc.dart';
import 'package:task_wizard/Features/Auth/Presentation/email_verification.dart';
import 'package:task_wizard/Features/Auth/Presentation/login_page.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/create_task_bloc.dart';
import 'package:task_wizard/Features/Landing/Presentation/FetchTaskBlocs/fetch_task_bloc.dart';
import 'package:task_wizard/Features/Landing/Presentation/Screens/landing_page.dart';
import 'package:task_wizard/Features/Profile/Presentation/Screens/profile_page.dart';
import 'package:task_wizard/Features/Profile/Presentation/UserBloc/user_bloc.dart';
import 'package:task_wizard/Features/ScheduledTasks/Presentation/Screens/task_schedule_screen.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/theme.dart';
import 'package:task_wizard/depencyInjection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => injector<AuthBloc>()),
        BlocProvider<AddTaskBloc>(create: (_) => injector<AddTaskBloc>()),
        BlocProvider<FetchTaskBloc>(create: (_) => injector<FetchTaskBloc>()),
        BlocProvider<UserBloc>(create: (_) => injector<UserBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(CheckIfFirstTimeEvent());
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) =>
                LandingPage()
            );
            case '/profile':
      final userId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ProfilePage(userId: userId),
      );
          // case '/notification-page':
          //   return MaterialPageRoute(builder: (context) {
          //     final ReceivedAction receivedAction = settings
          //         .arguments as ReceivedAction;
          //     return MyNotificationPage(receivedAction: receivedAction);
          //   });

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
      routes: {
        '/home': (context) => const LandingPage(),
        '/calendar': (context) => const TaskScheduleScreen(),
        '/chat': (context) => const LandingPage(),
        // '/profile': (context) => const ProfilePage(userId: '',),
      },
      home: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          builder: (_, state) {
            if (state is BannerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is IsFirstTime) {
              if (state.isFirstTime == 'onBoardingPage') {
                // return const OnBoardingPage();
              } else if (state.isFirstTime == 'LoginPage') {
                return const LoginPage();
              } else if (state.isFirstTime == 'HomePage') {
                return LandingPage();
              } else if (state.isFirstTime[state.isFirstTime.length - 1] ==
                  'E') {
                return EmailVerifcation(
                  email: state.isFirstTime.substring(
                    0,
                    state.isFirstTime.length - 1,
                  ),
                );
              }
            }

            return const LoginPage();
          },
          listener: (context, state) {
            if (state is Failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}

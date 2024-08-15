import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/authentication/bloc/authentication_bloc.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/core/auth_gate.dart';
import 'package:recipe_app/data/services/recipes_dio_service.dart';
import 'package:recipe_app/login_and_register/toggle_auth/toggle_auth_cubut.dart';
import 'package:recipe_app/splash/view/splash_page.dart';
import 'package:recipe_app/ui/screens/management_screen.dart';
import 'package:recipe_app/ui/screens/profile_screen.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserAuthRepository _userAuthRepository;
  late final UserRepository _userRepository;
  late final RecipesDioService _recipesDioService;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userAuthRepository = UserAuthRepository();
    _userRepository = UserRepository();
    _recipesDioService = RecipesDioService();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) => AuthenticationBloc(
              authenticationRepository: _authenticationRepository,
              userRepository: _userAuthRepository,
            )..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            lazy: false,
            create: (_) => ToggleAuthCubut(),
          ),
          BlocProvider(
            create: (context) => UserBloc(_userRepository),
            child: const ProfileView(),
          ),
          BlocProvider(
            lazy: false,
            create: (_) => RecipesBloc(recipesDioService: _recipesDioService),
          ),
          BlocProvider(
            lazy: false,
            create: (_) => AddRecipeBloc(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 840),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          onGenerateRoute: (_) => SplashPage.route(),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.push<void>(
                      MaterialPageRoute(
                          builder: (_) => const ManagementScreen(index: 0)),
                    );
                    break;
        
                  case AuthenticationStatus.unauthenticated:
                    _navigator.push<void>(
                      MaterialPageRoute(builder: (_) => const AuthGate()),
                    );
                    break;
        
                  case AuthenticationStatus.unknown:
                    break;
                }
              },
              child: child,
            );
          },
        );
      },
    );
  }
}

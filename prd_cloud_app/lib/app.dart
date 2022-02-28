import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/business_layer/business_layer.dart';
import 'package:prd_cloud_app/business_layer/tenant_options/cubit/tenant_options_cubit.dart';
import 'package:prd_cloud_app/home/home.dart';
import 'package:prd_cloud_app/login/login.dart';
import 'package:prd_cloud_app/splash/splash.dart';
import 'package:prd_cloud_app/tenant_selection/view/tenant_selection_page.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: authenticationRepository,
                  userRepository: userRepository)),
          BlocProvider<TenantSelectionCubit>(
              create: (_) => TenantSelectionCubit(
                  authenticationRepository: authenticationRepository)),
          BlocProvider<TenantOptionsCubit>(
              create: (_) => TenantOptionsCubit(
                  authenticationRepository: authenticationRepository)),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        
        var initialTenantSelectionState = context.select((TenantSelectionCubit bloc) => bloc.state);

        return BlocListener<TenantOptionsCubit, TenantOptionsState>(
            listener: (context, state) =>
                {}, // Start Cubit before token refresh on AuthenticationStatus.unknown
            child: BlocListener<TenantSelectionCubit, TenantSelectionState>(
              listener: (context, state) {
                tenantSelectionStateToView(state);
              },
              child: BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      tenantSelectionStateToView(initialTenantSelectionState);
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                        (route) => false,
                      );
                      break;
                    case AuthenticationStatus.unknown:
                      _navigator.pushAndRemoveUntil<void>(
                        InitialLoadingPage.route(),
                        (route) => false,
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: child,
              ),
            ));
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }

  void tenantSelectionStateToView(TenantSelectionState state) {
    if (state is TenantUnselected) {
      _navigator.pushAndRemoveUntil<void>(
        TenantSelectionPage.route(),
        (route) => false,
      );
    } else {
      _navigator.pushAndRemoveUntil<void>(
        HomePage.route(),
        (route) => false,
      );
    }
  }
}

class InitialLoadingPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => InitialLoadingPage());
  }

  @override
  Widget build(BuildContext context) {
    RepositoryProvider.of<AuthenticationRepository>(context).refreshToken();

    return const Scaffold(
        body: Padding(
            padding: EdgeInsets.all(12),
            child: Text("Setup", textAlign: TextAlign.center)));
  }
}

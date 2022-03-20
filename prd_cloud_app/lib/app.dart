import 'package:authentication_repository/authentication_repository.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/initial/bloc/auth_data_cubit/auth_data_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/authentication/authentication_bloc.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_options/tenant_options_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_selection/tenant_selection_cubit.dart';
import 'package:prd_cloud_app/modules/initial/screens/authenticated_provider/view/authenticated_provider.dart';
import 'package:prd_cloud_app/modules/initial/screens/login/view/login_page.dart';
import 'package:prd_cloud_app/modules/initial/screens/splash/view/splash_page.dart';
import 'package:prd_cloud_app/modules/initial/screens/tenant_selection/view/tenant_selection_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:prd_cloud_app/widgets/loading_scaffold.dart';

class App extends StatelessWidget {
  const App(
      {Key? key, required this.authenticationRepository, required this.config})
      : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final Config config;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider(create: (context) => ErrorRepository()),
        RepositoryProvider(create: (context) => config)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: authenticationRepository),
              lazy: false),
          BlocProvider(
              create: (_) => AuthDataCubit(
                  authenticationRepository: authenticationRepository),
              lazy: false),
          BlocProvider(
              create: (_) => TenantSelectionCubit(
                  authenticationRepository: authenticationRepository),
              lazy: false),
          BlocProvider(
              create: (_) => TenantOptionsCubit(
                  authenticationRepository: authenticationRepository),
              lazy: false)
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        child: MaterialApp(
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'AR'),
      ],
      // The Mandy red, light theme.
      theme: FlexThemeData.light(scheme: FlexScheme.bigStone),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.light,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                tenantSelectionStateToView(context.read<TenantSelectionCubit>().state);
                BlocListener<TenantSelectionCubit, TenantSelectionState>(
                  listener: (context, state) {
                    tenantSelectionStateToView(state);
                  }
                );
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
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    ));
  }

  void tenantSelectionStateToView(TenantSelectionState state) {
    if (state is TenantUnselected) {
      _navigator.pushAndRemoveUntil<void>(
        TenantSelectionPage.route(),
        (route) => false,
      );
    } else {
      _navigator.pushAndRemoveUntil<void>(
        AuthenticatedProviderPage.route(),
        (route) => false,
      );
    }
  }
}

class InitialLoadingPage extends StatelessWidget {
  const InitialLoadingPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const InitialLoadingPage());
  }

  @override
  Widget build(BuildContext context) {
    RepositoryProvider.of<AuthenticationRepository>(context).refreshToken();

    return const LoadingScaffold(text: "Carregando informações do usuário...");
  }
}

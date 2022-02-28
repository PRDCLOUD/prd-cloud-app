import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/authentication/authentication.dart';

class TenantSelectionPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TenantSelectionPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                final userId = context.select(
                  (AuthenticationBloc bloc) => bloc.state.user.id,
                );
                return Text('UserID: $userId');
              },
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
            ),
            ElevatedButton(
              child: const Text('Refresh'),
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationRefreshRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
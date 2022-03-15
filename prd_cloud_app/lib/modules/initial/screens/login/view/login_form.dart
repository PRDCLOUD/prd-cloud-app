import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/initial/screens/login/bloc/login_bloc.dart';
import 'package:prd_cloud_app/theme.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == SubmissionStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: 
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -1 / 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset('assets/img/logotipo.png')
                      ),
                      const Padding(padding: EdgeInsets.all(12)),
                      _LoginButton(),
                    ],
                  ),
                ),
              ),
              const Text("prdCloud® Todos os direitos reservados.", style: TextStyle(fontWeight: FontWeight.w600))
            ]
          )
        )
      );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SubmissionStatus.submissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  primary: AppThemeColors.primary,
                  minimumSize: const Size(120, 70),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                ),
                child: const Text('Clique Aqui para Logar'),
                onPressed: () { context.read<LoginBloc>().add(const LoginSubmitted()); }
              );
      },
    );
  }
}
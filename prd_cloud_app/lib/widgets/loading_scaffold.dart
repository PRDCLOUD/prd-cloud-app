import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({
    Key? key,
    required String text
  }) : _text = text, super(key: key);

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_text, textAlign: TextAlign.center),
                const SizedBox(height: 30),
                SpinKitFadingCube(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50.0,
                )
              ]
            )
          )
    );
  }
}

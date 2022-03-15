import 'package:flutter/material.dart';

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
          child: Center(child: Text(_text, textAlign: TextAlign.center)
        )
      )
    );
  }
}

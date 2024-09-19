import 'package:flutter/material.dart';
import 'package:payoff_matrix/states/translations_state.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(translations.notFoundScreen.notImplemented);
  }
}

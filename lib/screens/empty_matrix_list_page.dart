import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/active_screen_state.dart';

class EmptyMatrixListScreen extends ConsumerWidget {
  const EmptyMatrixListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Nada para ver aqui.',
              speed: const Duration(milliseconds: 90),
              textStyle: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () {
            ref.read(activeScreenIndex.notifier).state = 1;
          },
          icon: const Icon(Icons.add),
          label: const Text('Nova matriz de decisão'),
        )
      ],
    );
  }
}
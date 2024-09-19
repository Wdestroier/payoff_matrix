import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payoff_matrix/widgets/screen_router.dart';

import '../models/alternative.dart';
import '../models/nature_state.dart';
import '../repositories/matrix_repository.dart';
import '../states/active_screen_state.dart';
import '../states/editing_matrix_state.dart';
import '../states/translations_state.dart';
import 'expandable_fab.dart';
import 'mini_increment_fab.dart';

class DrawerDestination {
  final String label;
  final Widget icon;
  final Widget selectedIcon;

  const DrawerDestination(this.label, this.icon, this.selectedIcon);
}

final _destinations = <DrawerDestination>[
  DrawerDestination(
    translations.payoffMatrixApp.matrices,
    const Icon(Icons.list_alt_outlined),
    const Icon(Icons.list_alt),
  ),
  DrawerDestination(
    translations.payoffMatrixApp.newMatrix,
    const Icon(Icons.add_box_outlined),
    const Icon(Icons.add_box),
  ),
  DrawerDestination(
    translations.payoffMatrixApp.config,
    const Icon(Icons.settings_outlined),
    const Icon(Icons.settings),
  ),
];

class PayoffMatrixApp extends ConsumerStatefulWidget {
  const PayoffMatrixApp({super.key});

  @override
  ConsumerState<PayoffMatrixApp> createState() => _PayoffMatrixAppState();
}

class _PayoffMatrixAppState extends ConsumerState<PayoffMatrixApp> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late bool showNavigationDrawer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en'),
        //  Locale('pt'),
      ],
      home: Builder(
        builder: (context) {
          // Localizations.localeOf(context) is only available after the
          // MaterialApp widget is built.
          updateCurrentTranslations(context);

          return showNavigationDrawer
              ? buildDrawerScaffold(context)
              : buildBottomBarScaffold();
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  void handleScreenChanged(int selectedScreen) {
    final previousScreenController = ref.read(activeScreenIndex.notifier);
    if (selectedScreen == 1 && previousScreenController.state != 1) {
      updatePayoffMatrix(ref, null);
    }
    previousScreenController.state = selectedScreen;
  }

  Widget buildBottomBarScaffold() {
    final screenIndex = ref.watch(activeScreenIndex);
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: Center(
        child: ScreenRouter(screenIndex: screenIndex),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (int index) {
          handleScreenChanged(index);
        },
        destinations: _destinations.map(
          (DrawerDestination destination) {
            return NavigationDestination(
              label: destination.label,
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              tooltip: destination.label,
            );
          },
        ).toList(),
      ),
    );
  }

  Widget buildDrawerScaffold(BuildContext context) {
    final screenIndex = ref.watch(activeScreenIndex);
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: NavigationRail(
                labelType: NavigationRailLabelType.all,
                minWidth: 80,
                useIndicator: true,
                leading: const SizedBox(height: 2),
                destinations: _destinations.map(
                  (DrawerDestination destination) {
                    return NavigationRailDestination(
                      label: Text(destination.label),
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                    );
                  },
                ).toList(),
                selectedIndex: screenIndex,
                onDestinationSelected: (int index) {
                  handleScreenChanged(index);
                },
              ),
            ),
            Expanded(
              child: Center(
                child: ScreenRouter(
                  screenIndex: screenIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? buildFloatingActionButton() {
    final screenIndex = ref.watch(activeScreenIndex);
    final payoffMatrix = ref.watch(editingPayoffMatrix);

    return (screenIndex != 1 || payoffMatrix == null)
        ? null
        : ExpandableFab(
            distance: 112,
            children: [
              const SizedBox.shrink(),
              MiniIncrementFab(
                icon: Icons.alt_route,
                onPressed: () async {
                  payoffMatrix
                    ..alternatives.add(Alternative(
                      name:
                          '${translations.payoffMatrixApp.alternative} ${payoffMatrix.alternatives.length}',
                    ))
                    ..values.add(List<int>.filled(
                        payoffMatrix.natureStates.length, 0,
                        growable: true));
                  await MatrixRepository().update(payoffMatrix);
                  updatePayoffMatrix(ref, payoffMatrix);
                },
              ),
              const SizedBox.shrink(),
              MiniIncrementFab(
                icon: Icons.eco,
                onPressed: () async {
                  payoffMatrix
                    ..natureStates.add(NatureState(
                      name:
                          '${translations.payoffMatrixApp.natureState} ${payoffMatrix.natureStates.length}',
                      probability: 1.0,
                    ))
                    ..values.forEach((value) => value.add(0));
                  await MatrixRepository().update(payoffMatrix);
                  updatePayoffMatrix(ref, payoffMatrix);
                },
              ),
              const SizedBox.shrink(),
            ],
          );
  }
}

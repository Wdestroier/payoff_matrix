import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payoff_matrix/model.dart';
import 'package:ulid/ulid.dart';

import 'expandable_fab.dart';
import 'inline_editable_text.dart';
import 'service.dart';

final _activeScreenIndex = StateProvider<int>((ref) => 0);
final _editingPayoffMatrix = StateProvider<PayoffMatrix?>((ref) => null);

void main() async {
  await Hive.initFlutter();
  runApp(
    const ProviderScope(
      child: PayoffMatrixApp(),
    ),
  );
}

class DrawerDestination {
  final String label;
  final Widget icon;
  final Widget selectedIcon;

  const DrawerDestination(this.label, this.icon, this.selectedIcon);
}

const _destinations = <DrawerDestination>[
  DrawerDestination(
    'Matrizes',
    Icon(Icons.list_alt_outlined),
    Icon(Icons.list_alt),
  ),
  DrawerDestination(
    'Nova matriz',
    Icon(Icons.add_box_outlined),
    Icon(Icons.add_box),
  ),
  DrawerDestination(
    'Config',
    Icon(Icons.settings_outlined),
    Icon(Icons.settings),
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
      home: showNavigationDrawer
          ? buildDrawerScaffold(context)
          : buildBottomBarScaffold(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  void handleScreenChanged(int selectedScreen) {
    final previousScreenController = ref.read(_activeScreenIndex.notifier);
    if (selectedScreen == 1 && previousScreenController.state != 1) {
      updatePayoffMatrix(ref, null);
    }
    previousScreenController.state = selectedScreen;
  }

  Widget buildBottomBarScaffold() {
    final screenIndex = ref.watch(_activeScreenIndex);
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: Center(
        child: PageRouter(screenIndex: screenIndex),
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
    final screenIndex = ref.watch(_activeScreenIndex);
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
                child: PageRouter(
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
    final screenIndex = ref.watch(_activeScreenIndex);
    final payoffMatrix = ref.watch(_editingPayoffMatrix);

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
                      name: 'Alternativa ${payoffMatrix.alternatives.length}',
                    ))
                    ..values.add(List<int>.filled(
                        payoffMatrix.natureStates.length, 0,
                        growable: true));
                  await MatrixService().update(payoffMatrix);
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
                          'Estado da Natureza ${payoffMatrix.natureStates.length}',
                      probability: 1.0,
                    ))
                    ..values.forEach((value) => value.add(0));
                  await MatrixService().update(payoffMatrix);
                  updatePayoffMatrix(ref, payoffMatrix);
                },
              ),
              const SizedBox.shrink(),
            ],
          );
  }
}

class MiniIncrementFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const MiniIncrementFab({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      mini: true,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Icon(icon),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.scale(
              scale: 0.5,
              child: const Icon(Icons.exposure_plus_1),
            ),
          ),
        ],
      ),
    );
  }
}

class PageRouter extends ConsumerWidget {
  const PageRouter({
    super.key,
    required this.screenIndex,
  });

  final int screenIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payoffMatrix = ref.watch(_editingPayoffMatrix);
    return switch (screenIndex) {
      0 => const MatrixListPage(),
      1 => payoffMatrix == null
          ? const CreateMatrixScreen()
          : const EditMatrixScreen(),
      _ => const NotFoundPage(),
    };
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Não implementado.');
  }
}

class MatrixListPage extends StatelessWidget {
  const MatrixListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MatrixService().readAll(),
        builder: (context, snapshot) {
          return switch ((snapshot.hasData, snapshot.data)) {
            (false, _) => const Center(child: CircularProgressIndicator()),
            (true, final payoffMatrices)
                when payoffMatrices == null || payoffMatrices.isEmpty =>
              const EmptyMatrixListPage(),
            (true, final payoffMatrices) =>
              PopulatedMatrixListPage(payoffMatrices: payoffMatrices!),
          };
        });
  }
}

class PopulatedMatrixListPage extends ConsumerStatefulWidget {
  final List<PayoffMatrix> payoffMatrices;

  const PopulatedMatrixListPage({
    required this.payoffMatrices,
    super.key,
  });

  @override
  ConsumerState<PopulatedMatrixListPage> createState() =>
      _PopulatedMatrixListPageState();
}

class _PopulatedMatrixListPageState
    extends ConsumerState<PopulatedMatrixListPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: widget.payoffMatrices.map((payoffMatrix) {
          openEditView() {
            updatePayoffMatrix(ref, payoffMatrix);
            ref.read(_activeScreenIndex.notifier).state = 1;
          }

          final updatedAt = formatDateTime(payoffMatrix.updatedAt);
          return ListTile(
            onTap: openEditView,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: ulidToColor(payoffMatrix.id),
              ),
              height: 40,
              width: 40,
            ),
            title: Text(payoffMatrix.name),
            subtitle:
                Text('Atualizado em ${updatedAt.date} às ${updatedAt.time}'),
            trailing: SizedBox(
              width: 96,
              height: 64,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: 'Editar',
                    onPressed: openEditView,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded),
                    tooltip: 'Apagar',
                    onPressed: () async {
                      final deleted =
                          await MatrixService().delete(payoffMatrix.id);
                      if (deleted) {
                        setState(() {
                          widget.payoffMatrices.remove(payoffMatrix);
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  ({String date, String time}) formatDateTime(DateTime dateTime) {
    return (
      date:
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      time:
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}'
    );
  }

  Color ulidToColor(String ulid) {
    if (ulid.length != 26) {
      throw ArgumentError('ULID must be 26 characters long.');
    }
    final [r, g, b] = Ulid.parse(ulid).toBytes().reversed.take(3).toList();
    return Color.fromRGBO(r, g, b, 1.0);
  }
}

class EmptyMatrixListPage extends ConsumerWidget {
  const EmptyMatrixListPage({super.key});

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
            ref.read(_activeScreenIndex.notifier).state = 1;
          },
          icon: const Icon(Icons.add),
          label: const Text('Nova matriz de decisão'),
        )
      ],
    );
  }
}

class CreateMatrixScreen extends ConsumerWidget {
  const CreateMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nova matriz',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Flex(
              direction:
                  constraints.maxWidth > 450 ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    updatePayoffMatrix(
                        ref, await MatrixService().createUnderUncertainty());
                  },
                  child: const Text('Decisão sob incerteza'),
                ),
                const SizedBox(
                  width: 16,
                  height: 16,
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    updatePayoffMatrix(
                        ref, await MatrixService().createUnderRisk());
                  },
                  child: const Text('Decisão sob risco'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class EditMatrixScreen extends ConsumerWidget {
  const EditMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payoffMatrix = ref.watch(_editingPayoffMatrix)!;
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: InlineEditableText(
            payoffMatrix.name,
            style: Theme.of(context).textTheme.displayMedium,
            onSubmitted: (submittedName) {
              payoffMatrix.name = submittedName;
              MatrixService().update(payoffMatrix);
              updatePayoffMatrix(ref, payoffMatrix);
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DataTable2(
              dataRowHeight: 60,
              headingRowHeight:
                  payoffMatrix.decisionScenario == DecisionScenario.underRisk
                      ? 70
                      : null,
              columnSpacing: 12,
              horizontalMargin: 12,
              columns: [
                const DataColumn2(
                  label: Text('#'),
                ),
                ...payoffMatrix.natureStates
                    .mapIndexed((index, natureState) => DataColumn2(
                            label: Column(
                          children: [
                            InlineEditableText(
                              natureState.name,
                              onSubmitted: (submittedName) {
                                payoffMatrix.natureStates[index].name =
                                    submittedName;
                                MatrixService().update(payoffMatrix);
                                updatePayoffMatrix(ref, payoffMatrix);
                              },
                            ),
                            if (payoffMatrix.decisionScenario ==
                                DecisionScenario.underRisk) ...[
                              const Text('Probabilidade:'),
                              InlineEditableText(
                                natureState.probability.toStringAsFixed(2),
                                onSubmitted: (submittedName) {
                                  payoffMatrix.natureStates[index].probability =
                                      double.parse(submittedName);
                                  MatrixService().update(payoffMatrix);
                                  updatePayoffMatrix(ref, payoffMatrix);
                                },
                              ),
                            ]
                          ],
                        ))),
                const DataColumn2(label: Text('')),
                ...switch (payoffMatrix.decisionScenario) {
                  DecisionScenario.underUncertainty => [
                      const DataColumn2(label: Text('Maximax')),
                      const DataColumn2(label: Text('Maximin')),
                      const DataColumn2(label: Text('Laplace')),
                      const DataColumn2(label: Text('Savage')),
                      const DataColumn2(label: Text('Hurwicz α=1')),
                    ],
                  DecisionScenario.underRisk => [
                      const DataColumn2(label: Text('VEA')),
                      const DataColumn2(label: Text('VEIP')),
                    ]
                }
              ],
              rows: [
                ...payoffMatrix.values.mapIndexed((index, value) =>
                    DataRow(cells: [
                      DataCell(InlineEditableText(
                        payoffMatrix.alternatives[index].name,
                        onSubmitted: (submittedName) {
                          payoffMatrix.alternatives[index].name = submittedName;
                          MatrixService().update(payoffMatrix);
                          updatePayoffMatrix(ref, payoffMatrix);
                        },
                      )),
                      ...value.mapIndexed((index2, n) => DataCell(
                              InlineEditableText('$n',
                                  onSubmitted: (submittedNumber) {
                            payoffMatrix.values[index][index2] =
                                submittedNumber.isEmpty
                                    ? 0
                                    : int.parse(submittedNumber);
                            MatrixService().update(payoffMatrix);
                            updatePayoffMatrix(ref, payoffMatrix);
                          },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]))),
                      const DataCell(Text('')),
                      ...switch (payoffMatrix.decisionScenario) {
                        DecisionScenario.underUncertainty => [
                            DataCell(Text(maximax(value).toStringAsFixed(2))),
                            DataCell(Text(maximin(value).toStringAsFixed(2))),
                            DataCell(Text(laplace(value).toStringAsFixed(2))),
                            DataCell(Text(savage(value).toStringAsFixed(2))),
                            DataCell(Text(hurwicz(value).toStringAsFixed(2))),
                          ],
                        DecisionScenario.underRisk => [
                            DataCell(Text(
                                vea(payoffMatrix, value).toStringAsFixed(2))),
                            DataCell(Text(
                                veip(payoffMatrix, value).toStringAsFixed(2))),
                          ]
                      }
                    ])),
                if (payoffMatrix.decisionScenario ==
                    DecisionScenario.underUncertainty)
                  DataRow(
                    cells: () {
                      final bestAlternative =
                          buildBestAlternativeRow(payoffMatrix);

                      return [
                        DataCell(Wrap(
                          children: [
                            const Text('Melhor alternativa: '),
                            Text(bestAlternative.first),
                          ],
                        )),
                        ...bestAlternative
                            .skip(1)
                            .map((it) => DataCell(Text(it)))
                      ];
                    }(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  num vea(PayoffMatrix payoffMatrix, List<int> row) {
    return row
        .mapIndexed((index, value) =>
            value * payoffMatrix.natureStates[index].probability)
        .fold<num>(0, (prev, next) => prev + next);
  }

  num veip(PayoffMatrix payoffMatrix, List<int> row) {
    return row.mapIndexed((index, value) {
      final probability = payoffMatrix.natureStates[index].probability;
      final correctInfo = value * probability;
      final wrongInfo = value * (1 - probability);
      return correctInfo - wrongInfo;
    }).fold<num>(0, (prev, next) => prev + next);
  }

  num maximax(List<int> row) => row.max;

  num maximin(List<int> row) => row.min;

  num laplace(List<int> row) => row.average;

  num savage(List<int> row) {
    final variability = row.max - row.min;
    return (variability == 0 ? row.average : row.average / variability);
  }

  num hurwicz(List<int> row, [double optimismCoefficient = 1.0]) =>
      (row.max * optimismCoefficient + row.min * (1 - optimismCoefficient));

  List<String> buildBestAlternativeRow(PayoffMatrix payoffMatrix) {
    final bestMaximaxAlternative = getBestMaximaxAlternative(payoffMatrix);
    final bestMaximinAlternative = getBestMaximinAlternative(payoffMatrix);
    final bestLaplaceAlternative = getBestLaplaceAlternative(payoffMatrix);
    final bestSavageAlternative = getBestSavageAlternative(payoffMatrix);
    final bestHurwiczAlternative = getBestHurwiczAlternative(payoffMatrix);

    final bestAlternativeName = payoffMatrix
        .alternatives[getBestAlternativeIndex([
      bestMaximaxAlternative.index,
      bestMaximinAlternative.index,
      bestLaplaceAlternative.index,
      bestSavageAlternative.index,
      bestHurwiczAlternative.index,
    ])]
        .name;

    return [
      bestAlternativeName,
      for (var i = 0; i < payoffMatrix.natureStates.length; i++) '',
      '',
      bestMaximaxAlternative.value.toStringAsFixed(2),
      bestMaximinAlternative.value.toStringAsFixed(2),
      bestLaplaceAlternative.value.toStringAsFixed(2),
      bestSavageAlternative.value.toStringAsFixed(2),
      bestHurwiczAlternative.value.toStringAsFixed(2),
    ];
  }

  int getBestAlternativeIndex(List<int> alternatives) {
    return (<int, int>{}
          ..update(alternatives[0], (value) => value + 1, ifAbsent: () => 1)
          ..update(alternatives[1], (value) => value + 1, ifAbsent: () => 1)
          ..update(alternatives[2], (value) => value + 1, ifAbsent: () => 1)
          ..update(alternatives[3], (value) => value + 1, ifAbsent: () => 1)
          ..update(alternatives[4], (value) => value + 1, ifAbsent: () => 1))
        .entries
        .reduce((first, second) => first.value > second.value ? first : second)
        .key;
  }

  ({int index, num value}) getBestMaximaxAlternative(
      PayoffMatrix payoffMatrix) {
    int bestIndex = 0;
    num bestValue = maximax(payoffMatrix.values.first);

    for (var (currentIndex, currentRow) in payoffMatrix.values.indexed) {
      final currentValue = maximax(currentRow);
      if (currentValue > bestValue) {
        bestIndex = currentIndex;
        bestValue = currentValue;
      }
    }

    return (index: bestIndex, value: bestValue);
  }

  ({int index, num value}) getBestMaximinAlternative(
      PayoffMatrix payoffMatrix) {
    int bestIndex = 0;
    num bestValue = maximin(payoffMatrix.values.first);

    for (var (currentIndex, currentRow) in payoffMatrix.values.indexed) {
      final currentValue = maximin(currentRow);
      if (currentValue > bestValue) {
        bestIndex = currentIndex;
        bestValue = currentValue;
      }
    }

    return (index: bestIndex, value: bestValue);
  }

  ({int index, num value}) getBestLaplaceAlternative(
      PayoffMatrix payoffMatrix) {
    int bestIndex = 0;
    num bestValue = laplace(payoffMatrix.values.first);
    final average = payoffMatrix.values.map(laplace).average;

    for (var (currentIndex, currentRow) in payoffMatrix.values.indexed) {
      final currentValue = laplace(currentRow);

      if ((currentValue - average).abs() < (bestValue - average).abs()) {
        bestIndex = currentIndex;
        bestValue = currentValue;
      }
    }

    return (index: bestIndex, value: bestValue);
  }

  ({int index, num value}) getBestSavageAlternative(PayoffMatrix payoffMatrix) {
    int bestIndex = 0;
    num bestValue = savage(payoffMatrix.values.first);

    for (var (currentIndex, currentRow) in payoffMatrix.values.indexed) {
      final currentValue = savage(currentRow);
      if (currentValue > bestValue) {
        bestIndex = currentIndex;
        bestValue = currentValue;
      }
    }

    return (index: bestIndex, value: bestValue);
  }

  ({int index, num value}) getBestHurwiczAlternative(
      PayoffMatrix payoffMatrix) {
    int bestIndex = 0;
    num bestValue = hurwicz(payoffMatrix.values.first);

    for (var (currentIndex, currentRow) in payoffMatrix.values.indexed) {
      final currentValue = hurwicz(currentRow);
      if (currentValue > bestValue) {
        bestIndex = currentIndex;
        bestValue = currentValue;
      }
    }

    return (index: bestIndex, value: bestValue);
  }
}

updatePayoffMatrix(WidgetRef ref, PayoffMatrix? payoffMatrix) {
  ref.read(_editingPayoffMatrix.notifier).state = null;
  ref.read(_editingPayoffMatrix.notifier).state = payoffMatrix;
}

import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/decision_scenario.dart';
import '../models/payoff_matrix.dart';
import '../repositories/matrix_repository.dart';
import '../states/editing_matrix_state.dart';
import '../widgets/inline_editable_text.dart';

class EditMatrixScreen extends ConsumerWidget {
  const EditMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payoffMatrix = ref.watch(editingPayoffMatrix)!;
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
              MatrixRepository().update(payoffMatrix);
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
                                MatrixRepository().update(payoffMatrix);
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
                                  MatrixRepository().update(payoffMatrix);
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
                          MatrixRepository().update(payoffMatrix);
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
                            MatrixRepository().update(payoffMatrix);
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

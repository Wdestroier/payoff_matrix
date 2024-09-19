import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/payoff_matrix_app.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const PayoffMatrixApp());
}

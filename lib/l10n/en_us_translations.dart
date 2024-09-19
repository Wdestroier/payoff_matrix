import 'translations.dart';

class EnUsTranslations extends Translations {
  @override
  CreateMatrixScreenTranslations get createMatrixScreen =>
      CreateMatrixScreenEnUsTranslations();
  @override
  EditMatrixScreenTranslations get editMatrixScreen =>
      EditMatrixScreenEnUsTranslations();
  @override
  EmptyMatrixListScreenTranslations get emptyMatrixListScreen =>
      EmptyMatrixListScreenEnUsTranslations();
  @override
  NotFoundScreenTranslations get notFoundScreen =>
      NotFoundScreenEnUsTranslations();
  @override
  PopulatedMatrixListScreenTranslations get populatedMatrixListScreen =>
      PopulatedMatrixListScreenEnUsTranslations();
  @override
  MatrixServiceTranslations get matrixService =>
      MatrixServiceEnUsTranslations();
  @override
  PayoffMatrixAppTranslations get payoffMatrixApp =>
      PayoffMatrixAppEnUsTranslations();
}

class CreateMatrixScreenEnUsTranslations
    extends CreateMatrixScreenTranslations {
  @override
  String get newMatrix => 'New matrix';
  @override
  String get decisionUnderUncertainty => 'Decision under uncertainty';
  @override
  String get decisionUnderRisk => 'Decision under risk';
}

class EditMatrixScreenEnUsTranslations extends EditMatrixScreenTranslations {
  @override
  String get probability => 'Probability';
  @override
  String get maximax => 'Maximax';
  @override
  String get maximin => 'Maximin';
  @override
  String get laplace => 'Laplace';
  @override
  String get savage => 'Savage';
  @override
  String get hurwicz => 'Hurwicz';
  @override
  String get vea => 'VEA';
  @override
  String get veip => 'VEIP';
  @override
  String get melhorAlternativa => 'Best alternative';
}

class EmptyMatrixListScreenEnUsTranslations
    extends EmptyMatrixListScreenTranslations {
  @override
  String get nothingToSeeHere => 'Nothing to see here';
  @override
  String get newDecisionMatrix => 'New decision matrix';
}

class NotFoundScreenEnUsTranslations extends NotFoundScreenTranslations {
  @override
  String get notImplemented => 'Not implemented.';
}

class PopulatedMatrixListScreenEnUsTranslations
    extends PopulatedMatrixListScreenTranslations {
  @override
  String updatedOnAt(String date, String time) => 'Updated on $date at $time';
  @override
  String get edit => 'Edit';
  @override
  String get delete => 'Delete';
}

class MatrixServiceEnUsTranslations extends MatrixServiceTranslations {
  @override
  String get newMatrix => 'New matrix';
  @override
  String get natureState => 'State of nature';
  @override
  String get alternative => 'Alternative';
}

class PayoffMatrixAppEnUsTranslations extends PayoffMatrixAppTranslations {
  @override
  String get alternative => 'Alternative';
  @override
  String get natureState => 'State of nature';
  @override
  String get matrices => 'Matrices';
  @override
  String get newMatrix => 'New matrix';
  @override
  String get config => 'Config';
}

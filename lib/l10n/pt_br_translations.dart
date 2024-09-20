import 'translations.dart';

class PtBrTranslations extends Translations {
  @override
  CreateMatrixScreenTranslations get createMatrixScreen =>
      CreateMatrixScreenPtBrTranslations();
  @override
  EditMatrixScreenTranslations get editMatrixScreen =>
      EditMatrixScreenPtBrTranslations();
  @override
  EmptyMatrixListScreenTranslations get emptyMatrixListScreen =>
      EmptyMatrixListScreenPtBrTranslations();
  @override
  NotFoundScreenTranslations get notFoundScreen =>
      NotFoundScreenPtBrTranslations();
  @override
  PopulatedMatrixListScreenTranslations get populatedMatrixListScreen =>
      PopulatedMatrixListScreenPtBrTranslations();
  @override
  MatrixServiceTranslations get matrixService =>
      MatrixServicePtBrTranslations();
  @override
  PayoffMatrixAppTranslations get payoffMatrixApp =>
      PayoffMatrixAppPtBrTranslations();
}

class CreateMatrixScreenPtBrTranslations
    extends CreateMatrixScreenTranslations {
  @override
  String get newMatrix => 'Nova matriz';
  @override
  String get decisionUnderUncertainty => 'Decisão sob incerteza';
  @override
  String get decisionUnderRisk => 'Decisão sob risco';
}

class EditMatrixScreenPtBrTranslations extends EditMatrixScreenTranslations {
  @override
  String get probability => 'Probabilidade';
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
  String get melhorAlternativa => 'Melhor alternativa';
}

class EmptyMatrixListScreenPtBrTranslations
    extends EmptyMatrixListScreenTranslations {
  @override
  String get nothingToSeeHere => 'Nada para ver aqui';
  @override
  String get newDecisionMatrix => 'Nova matriz de decisão';
}

class NotFoundScreenPtBrTranslations extends NotFoundScreenTranslations {
  @override
  String get notImplemented => 'Não implementado.';
}

class PopulatedMatrixListScreenPtBrTranslations
    extends PopulatedMatrixListScreenTranslations {
  @override
  String updatedOnAt(String date, String time) =>
      'Atualizado em $date às $time';
  @override
  String get edit => 'Editar';
  @override
  String get delete => 'Apagar';
}

class MatrixServicePtBrTranslations extends MatrixServiceTranslations {
  @override
  String get newMatrix => 'Nova matriz';
  @override
  String get natureState => 'Estado da Natureza';
  @override
  String get alternative => 'Alternativa';
}

class PayoffMatrixAppPtBrTranslations extends PayoffMatrixAppTranslations {
  @override
  String get alternative => 'Alternativa';
  @override
  String get natureState => 'Estado da Natureza';
  @override
  String get matrices => 'Matrizes';
  @override
  String get newMatrix => 'Nova matriz';
  @override
  String get config => 'Config';
}

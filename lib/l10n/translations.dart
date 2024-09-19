abstract class Translations {
  CreateMatrixScreenTranslations get createMatrixScreen;
  EditMatrixScreenTranslations get editMatrixScreen;
  EmptyMatrixListScreenTranslations get emptyMatrixListScreen;
  NotFoundScreenTranslations get notFoundScreen;
  PopulatedMatrixListScreenTranslations get populatedMatrixListScreen;
  MatrixServiceTranslations get matrixService;
  PayoffMatrixAppTranslations get payoffMatrixApp;
}

abstract class CreateMatrixScreenTranslations {
  String get newMatrix;
  String get decisionUnderUncertainty;
  String get decisionUnderRisk;
}

abstract class EditMatrixScreenTranslations {
  String get probability;
  String get maximax;
  String get maximin;
  String get laplace;
  String get savage;
  String get hurwicz;
  String get vea;
  String get veip;
  String get melhorAlternativa;
}

abstract class EmptyMatrixListScreenTranslations {
  String get nothingToSeeHere;
  String get newDecisionMatrix;
}

abstract class NotFoundScreenTranslations {
  String get notImplemented;
}

abstract class PopulatedMatrixListScreenTranslations {
  String updatedOnAt(String date, String time);
  String get edit;
  String get delete;
}

abstract class MatrixServiceTranslations {
  String get newMatrix;
  String get natureState;
  String get alternative;
}

abstract class PayoffMatrixAppTranslations {
  String get alternative;
  String get natureState;
  String get matrices;
  String get newMatrix;
  String get config;
}

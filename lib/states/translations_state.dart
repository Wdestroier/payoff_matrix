import 'package:flutter/material.dart';

import '../l10n/en_us_translations.dart';
import '../l10n/pt_br_translations.dart';
import '../l10n/translations.dart';

bool translationsSet = false;
late final Translations translations;

void updateCurrentTranslations(BuildContext context) {
  if (!translationsSet) {
    final currentLocale = Localizations.localeOf(context);
    translations = (currentLocale.languageCode == 'pt')
        ? PtBrTranslations()
        : EnUsTranslations();
    translationsSet = true;
  }
}

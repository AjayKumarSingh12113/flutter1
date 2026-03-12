import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}

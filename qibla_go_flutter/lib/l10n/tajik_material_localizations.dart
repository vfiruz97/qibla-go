import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

/// Flutter ships no Material, Cupertino or widgets strings for Tajik, so for
/// `tg` the framework would fall back to English for its own chrome: the
/// back-button tooltip, the text-selection menu, sheet and scrim labels.
/// These classes translate the strings a user of this app can actually meet
/// and leave the rest (date and time pickers, licence pages, keyboard key
/// names) on the English defaults. Add them before the generated delegates.
const List<LocalizationsDelegate<dynamic>> tajikLocalizationsDelegates = [
  _TajikMaterialDelegate(),
  _TajikCupertinoDelegate(),
  _TajikWidgetsDelegate(),
];

const _tajik = Locale('tg');

bool _isTajik(Locale locale) => locale.languageCode == _tajik.languageCode;

class TajikMaterialLocalizations extends DefaultMaterialLocalizations {
  const TajikMaterialLocalizations();

  @override
  String get backButtonTooltip => 'Бозгашт';
  @override
  String get closeButtonLabel => 'Пӯшидан';
  @override
  String get closeButtonTooltip => 'Пӯшидан';
  @override
  String get modalBarrierDismissLabel => 'Пӯшидан';
  @override
  String get menuDismissLabel => 'Пӯшидани меню';
  @override
  String get bottomSheetLabel => 'Варақи поёнӣ';
  @override
  String get dialogLabel => 'Равзанаи муколама';
  @override
  String get alertDialogLabel => 'Огоҳӣ';
  @override
  String get drawerLabel => 'Менюи паймоиш';
  @override
  String get popupMenuLabel => 'Менюи зоҳиршаванда';
  @override
  String get menuBarMenuLabel => 'Меню';
  @override
  String get scrimLabel => 'Парда';
  @override
  String scrimOnTapHint(String modalRouteContentName) =>
      'Пӯшидани $modalRouteContentName';
  @override
  String get okButtonLabel => 'Хуб';
  @override
  String get cancelButtonLabel => 'Бекор кардан';
  @override
  String get continueButtonLabel => 'Давом додан';
  @override
  String get saveButtonLabel => 'Нигоҳ доштан';
  @override
  String get deleteButtonTooltip => 'Нест кардан';
  @override
  String get clearButtonTooltip => 'Пок кардан';
  @override
  String get moreButtonTooltip => 'Бештар';
  @override
  String get showMenuTooltip => 'Нишон додани меню';
  @override
  String get openAppDrawerTooltip => 'Кушодани менюи паймоиш';
  @override
  String get searchFieldLabel => 'Ҷустуҷӯ';
  @override
  String get refreshIndicatorSemanticLabel => 'Навсозӣ';
  @override
  String get cutButtonLabel => 'Буридан';
  @override
  String get copyButtonLabel => 'Нусха бардоштан';
  @override
  String get pasteButtonLabel => 'Гузоштан';
  @override
  String get selectAllButtonLabel => 'Ҳамаро интихоб кардан';
  @override
  String get lookUpButtonLabel => 'Ҷустуҷӯ';
  @override
  String get searchWebButtonLabel => 'Дар интернет ҷустуҷӯ кардан';
  @override
  String get shareButtonLabel => 'Мубодила кардан';
  @override
  String get scanTextButtonLabel => 'Скан кардани матн';
  @override
  String get expandedHint => 'Васеъ карда шуд';
  @override
  String get collapsedHint => 'Печонда шуд';
  @override
  String get expandedIconTapHint => 'Печондан';
  @override
  String get collapsedIconTapHint => 'Васеъ кардан';
  @override
  String get expansionTileExpandedHint => 'барои печондан ду бор ламс кунед';
  @override
  String get expansionTileCollapsedHint =>
      'барои васеъ кардан ду бор ламс кунед';
  @override
  String get expansionTileExpandedTapHint => 'Печондан';
  @override
  String get expansionTileCollapsedTapHint => 'Васеъ кардан';
}

class TajikCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const TajikCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Огоҳӣ';
  @override
  String get modalBarrierDismissLabel => 'Пӯшидан';
  @override
  String get menuDismissLabel => 'Пӯшидани меню';
  @override
  String get clearButtonLabel => 'Пок кардан';
  @override
  String get cutButtonLabel => 'Буридан';
  @override
  String get copyButtonLabel => 'Нусха бардоштан';
  @override
  String get pasteButtonLabel => 'Гузоштан';
  @override
  String get selectAllButtonLabel => 'Ҳамаро интихоб кардан';
  @override
  String get lookUpButtonLabel => 'Ҷустуҷӯ';
  @override
  String get searchWebButtonLabel => 'Дар интернет ҷустуҷӯ кардан';
  @override
  String get shareButtonLabel => 'Мубодила кардан';
  @override
  String get noSpellCheckReplacementsLabel => 'Ивазкунӣ ёфт нашуд';
}

class TajikWidgetsLocalizations extends DefaultWidgetsLocalizations {
  const TajikWidgetsLocalizations();

  @override
  String get cutButtonLabel => 'Буридан';
  @override
  String get copyButtonLabel => 'Нусха бардоштан';
  @override
  String get pasteButtonLabel => 'Гузоштан';
  @override
  String get selectAllButtonLabel => 'Ҳамаро интихоб кардан';
  @override
  String get lookUpButtonLabel => 'Ҷустуҷӯ';
  @override
  String get searchWebButtonLabel => 'Дар интернет ҷустуҷӯ кардан';
  @override
  String get shareButtonLabel => 'Мубодила кардан';
  @override
  String get reorderItemToStart => 'Ба аввал кӯчонидан';
  @override
  String get reorderItemToEnd => 'Ба охир кӯчонидан';
  @override
  String get reorderItemUp => 'Ба боло кӯчонидан';
  @override
  String get reorderItemDown => 'Ба поён кӯчонидан';
  @override
  String get reorderItemLeft => 'Ба чап кӯчонидан';
  @override
  String get reorderItemRight => 'Ба рост кӯчонидан';
}

class _TajikMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _TajikMaterialDelegate();
  @override
  bool isSupported(Locale locale) => _isTajik(locale);
  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(const TajikMaterialLocalizations());
  @override
  bool shouldReload(_TajikMaterialDelegate old) => false;
}

class _TajikCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _TajikCupertinoDelegate();
  @override
  bool isSupported(Locale locale) => _isTajik(locale);
  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture(const TajikCupertinoLocalizations());
  @override
  bool shouldReload(_TajikCupertinoDelegate old) => false;
}

class _TajikWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _TajikWidgetsDelegate();
  @override
  bool isSupported(Locale locale) => _isTajik(locale);
  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture(const TajikWidgetsLocalizations());
  @override
  bool shouldReload(_TajikWidgetsDelegate old) => false;
}

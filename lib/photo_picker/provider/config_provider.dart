import 'package:flutter/material.dart'; import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:Oneblock/photo_picker/entity/options.dart';
import 'package:Oneblock/photo_picker/provider/i18n_provider.dart';

class ConfigProvider extends InheritedWidget {
  final Options options;
  final I18nProvider provider;

  ConfigProvider({
    @required this.options,
    @required this.provider,
    @required Widget child,
    Key key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ConfigProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ConfigProvider);
}

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_asset_picker/src/models/picker_config.dart';
import 'package:simple_asset_picker/src/views/picker_page.dart';

class Picker {
  static late PickerConfig _pickerConfig;

  static PickerConfig get pickerConfig => _pickerConfig;

  static Future<List<AssetEntity>> pickAssets(
    BuildContext context, {
    PickerConfig pickerConfig = const PickerConfig(),
  }) async {
    _pickerConfig = pickerConfig;
    final result = await Navigator.of(context).push<List<AssetEntity>>(
      MaterialPageRoute(
        builder: (context) => const PickerPage(),
      ),
    );
    return result ?? [];
  }
}

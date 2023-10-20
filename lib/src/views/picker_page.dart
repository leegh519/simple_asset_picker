import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_asset_picker/src/views/picker_appbar.dart';
import 'package:simple_asset_picker/src/views/picker_asset_grid.dart';
import 'package:simple_asset_picker/src/views/selected_image_preview.dart';

class PickerPage extends StatelessWidget {
  const PickerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            PickerAppbar(),
            SelectedImagePreview(),
            PickerAssetGrid(),
          ],
        ),
      ),
    );
  }
}

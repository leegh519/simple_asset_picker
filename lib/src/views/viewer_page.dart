import 'package:flutter/material.dart';
import 'package:simple_asset_picker/src/views/image_viewer.dart';
import 'package:simple_asset_picker/src/views/viewer_appbar.dart';

class ViewerPage extends StatelessWidget {
  const ViewerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          ViewerAppbar(),
          ImageViewer(),
        ],
      ),
    );
  }
}

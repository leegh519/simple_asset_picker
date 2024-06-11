import 'package:flutter/material.dart';
import 'package:simple_asset_picker/src/views/picker_asset_grid.dart';

class TakeMediaDialog extends StatelessWidget {
  const TakeMediaDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '촬영',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop(CameraType.image);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '사진 촬영',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop(CameraType.video);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '동영상 촬영',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

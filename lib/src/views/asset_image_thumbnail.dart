import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_asset_picker/src/provider/asset_provider.dart';
import 'package:simple_asset_picker/src/util/util.dart';
import 'package:simple_asset_picker/src/views/picker.dart';
import 'package:simple_asset_picker/src/views/viewer_page.dart';

class AssetImageThumbnail extends ConsumerWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const AssetImageThumbnail({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickerConfig = Picker.pickerConfig;
    final imageSize =
        (MediaQuery.of(context).size.width / pickerConfig.gridCount);
    final selectedAssets = ref.watch(selectedAssetProvider);
    final isSelected = selectedAssets.contains(asset);
    final count = selectedAssets.indexOf(asset) + 1;

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 사진
            Container(
              // 선택한 사진 표시
              decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(
                        color: pickerConfig.mainColor,
                        width: 3,
                      )
                    : null,
              ),
              child: Hero(
                tag: asset.id,
                child: AssetEntityImage(
                  asset,
                  isOriginal: false,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Material(
                      color: Colors.black,
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: imageSize / 5,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 선택 동그라미
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(imageSize / 20),
                child: isSelected
                    // 선택한 사진
                    ? Container(
                        width: imageSize / 5.5,
                        height: imageSize / 5.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pickerConfig.mainColor,
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              color: pickerConfig.brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaleFactor: 1,
                          ),
                        ),
                      )
                    // 선택안한 사진
                    : Container(
                        width: imageSize / 5.5,
                        height: imageSize / 5.5,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(115, 155, 155, 155),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(185, 255, 255, 255),
                          ),
                        ),
                      ),
              ),
            ),

            // 미리보기 버튼
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(imageSize / 30),
                child: GestureDetector(
                  onTap: () {
                    ref.watch(previewAssetProvider.notifier).update(
                          (state) => state = asset,
                        );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ViewerPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: imageSize / 5,
                    height: imageSize / 5,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image,
                      color: Colors.white,
                      size: imageSize / 5,
                    ),
                  ),
                ),
              ),
            ),

            // 영상길이 표시
            if (asset.type == AssetType.video)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(imageSize / 20),
                  child: Container(
                    width: imageSize / 3.5,
                    height: imageSize / 8,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        Util.durationFormat(asset.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontSize: 14,
                          letterSpacing: -0.4,
                        ),
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

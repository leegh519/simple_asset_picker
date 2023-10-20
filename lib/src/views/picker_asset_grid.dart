import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_asset_picker/src/provider/asset_provider.dart';
import 'package:simple_asset_picker/src/provider/asset_path_provider.dart';
import 'package:simple_asset_picker/src/views/asset_image_thumbnail.dart';
import 'package:simple_asset_picker/src/views/picker.dart';

class PickerAssetGrid extends ConsumerStatefulWidget {
  const PickerAssetGrid({
    super.key,
  });

  @override
  ConsumerState<PickerAssetGrid> createState() => _PickerAssetListState();
}

class _PickerAssetListState extends ConsumerState<PickerAssetGrid> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    final selectedPath = ref.watch(selectedPathProvider);
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      if (selectedPath != null) {
        ref
            .watch(assetProvider(selectedPath.assetPathEntity.id).notifier)
            .getAssetList(getMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickerConfig = Picker.pickerConfig;
    final imageSize =
        MediaQuery.of(context).size.width / pickerConfig.gridCount;
    final selectedPath = ref.watch(selectedPathProvider);

    final hasPermission = ref.watch(assetPathProvider.notifier).hasPermission;
    final paths = ref.watch(assetPathProvider);

    // 사진 로딩
    if (paths == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 권한 없음
    if (!hasPermission) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Text('갤러리 접근 권한이 없습니다.'),
        ),
      );
    }

    // 사진 없음
    if (paths.isEmpty || selectedPath == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Text('갤러리에 사진이 없습니다.'),
        ),
      );
    }

    final list = ref.watch(assetProvider(selectedPath.assetPathEntity.id));

    return Expanded(
      child: GridView.count(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        controller: controller,
        crossAxisCount: pickerConfig.gridCount,
        children: [
          if (Picker.pickerConfig.useCamera)
            Padding(
              padding: const EdgeInsets.all(1.5),
              child: Container(
                color: Colors.grey[400],
                alignment: Alignment.center,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: imageSize / 3,
                ),
              ),
            ),
          ...list.map(
            (asset) {
              return AssetImageThumbnail(
                asset: asset,
                onTap: () {
                  final isAdded = ref
                      .watch(selectedAssetProvider.notifier)
                      .selecteAsset(asset);
                  if (!isAdded) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          shape: StadiumBorder(),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 1500),
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 24,
                          ),
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          content: Text(
                            '더 이상 선택할 수 없습니다.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                  }
                },
              );
            },
          ).toList()
        ],
      ),
    );
  }
}

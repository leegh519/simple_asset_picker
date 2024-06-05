import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_asset_picker/src/models/asset_path.dart';
import 'package:simple_asset_picker/src/views/picker.dart';

final selectedPathProvider = StateProvider<AssetPath?>((ref) {
  return null;
});

final assetPathProvider =
    StateNotifierProvider.autoDispose<AssetPathNotifier, List<AssetPath>?>(
        (ref) {
  return AssetPathNotifier(ref: ref);
});

class AssetPathNotifier extends StateNotifier<List<AssetPath>?> {
  final Ref ref;
  bool hasPermission = true;

  AssetPathNotifier({
    required this.ref,
  }) : super(null) {
    requestsPermission().then((_) {
      getAlbumList();
    });
  }

  Future<void> requestsPermission() async {
    // 권한 요청
    final permissionState = await PhotoManager.requestPermissionExtend();
    if (permissionState.hasAccess) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
    // state = state.copyWith();
  }

  Future<void> getAlbumList() async {
    // 권한 없음
    if (!hasPermission) {
      state = [];
      return;
    }
    final requestType = Picker.pickerConfig.requestType;
    final List<AssetPath> assetPaths = [];

    // 앨범 목록 불러오기
    final paths = await PhotoManager.getAssetPathList(
      type: requestType,
      filterOption: FilterOptionGroup(
          // imageOption: const FilterOption(
          //   sizeConstraint: SizeConstraint(ignoreSize: true),
          // ),
          ),
    );

    // 앨범 사진 수 불러오기
    for (var assetPathEntity in paths) {
      int count = await assetPathEntity.assetCountAsync;
      if (count != 0) {
        if (assetPathEntity.name.contains('Recent')) {
          assetPathEntity = assetPathEntity.copyWith(name: '전체보기');
        }
        final assetPath =
            AssetPath(count: count, assetPathEntity: assetPathEntity);
        assetPaths.add(assetPath);
      }
    }

    // 첫번째 앨범 선택한 앨범으로 지정
    if (assetPaths.isNotEmpty) {
      ref
          .watch(selectedPathProvider.notifier)
          .update((state) => state = assetPaths.first);
    }
    state = assetPaths;
  }
}

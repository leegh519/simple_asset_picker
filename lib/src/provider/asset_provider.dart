import 'package:collection/collection.dart';
import 'package:simple_asset_picker/simple_asset_picker.dart';
import 'package:simple_asset_picker/src/models/asset_parameter.dart';
import 'package:simple_asset_picker/src/models/asset_path.dart';
import 'package:simple_asset_picker/src/provider/asset_path_provider.dart';

// final pickerConfigProvider = Provider<PickerConfig>((ref) {
//   return const PickerConfig();
// });

final previewAssetProvider =
    StateProvider.autoDispose<AssetEntity?>((ref) => null);

final selectedAssetProvider =
    StateNotifierProvider.autoDispose<SelectedAssetNotifier, List<AssetEntity>>(
  (ref) => SelectedAssetNotifier(),
);

class SelectedAssetNotifier extends StateNotifier<List<AssetEntity>> {
  SelectedAssetNotifier() : super([]) {
    if (Picker.pickerConfig.selectedAssets != null) {
      state = Picker.pickerConfig.selectedAssets!;
    }
  }

  bool selecteAsset(AssetEntity asset) {
    final isSelected = state.contains(asset);
    if (isSelected) {
      state.remove(asset);
      state = [...state];
    } else {
      if (Picker.pickerConfig.maxAssets != null &&
          state.length >= Picker.pickerConfig.maxAssets!) {
        return false;
      } else {
        state = [...state, asset];
      }
    }
    return true;
  }
}

final assetProvider = StateNotifierProvider.family
    .autoDispose<AssetNotifier, List<AssetEntity>, String>(
  (ref, id) {
    final paths = ref.watch(assetPathProvider)!;
    final path = paths.firstWhereOrNull(
      (element) => element.assetPathEntity.id == id,
    );
    return AssetNotifier(path: path);
  },
);

class AssetNotifier extends StateNotifier<List<AssetEntity>> {
  final AssetPath? path;
  AssetParameter parameter = const AssetParameter();
  bool isLoading = false;

  AssetNotifier({
    required this.path,
  }) : super([]) {
    getAssetList();
  }

  void getAssetList({
    bool getMore = false,
  }) async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    if (path == null) {
      return;
    }

    if (getMore) {
      parameter = parameter.copyWith(page: parameter.page + 1);
      final assets = await path!.assetPathEntity.getAssetListPaged(
        page: parameter.page,
        size: Picker.pickerConfig.pageSize,
      );
      state = [...state, ...assets];
    } else {
      state = await path!.assetPathEntity.getAssetListPaged(
        page: parameter.page,
        size: Picker.pickerConfig.pageSize,
      );
    }
    isLoading = false;
  }
}

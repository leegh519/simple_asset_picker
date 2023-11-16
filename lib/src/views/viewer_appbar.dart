import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_asset_picker/src/provider/asset_path_provider.dart';
import 'package:simple_asset_picker/src/provider/asset_provider.dart';
import 'package:simple_asset_picker/src/views/picker.dart';

class ViewerAppbar extends ConsumerWidget {
  const ViewerAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final pickerConfig = Picker.pickerConfig;
    final asset = ref.watch(previewAssetProvider)!;
    final selectedPath = ref.watch(selectedPathProvider);
    final list = selectedPath == null
        ? []
        : ref.watch(assetProvider(selectedPath.assetPathEntity.id));
    final index = list.indexOf(asset) + 1;
    final selectedAssets = ref.watch(selectedAssetProvider);

    return Container(
      width: double.maxFinite,
      height: 50 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Text(
            '$index / ${selectedPath?.count}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
            textScaler: TextScaler.noScaling,
          ),
          const Spacer(),
          if (selectedAssets.isNotEmpty)
            Text(
              '${selectedAssets.length}',
              style: TextStyle(
                color: pickerConfig.mainColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (selectedAssets.isNotEmpty && pickerConfig.maxAssets != null)
            Text(
              '/${pickerConfig.maxAssets}',
              style: TextStyle(
                color: pickerConfig.mainColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pop(selectedAssets);
              ref
                  .watch(selectedPathProvider.notifier)
                  .update((state) => state = null);
            },
            child: Text(
              '  완료',
              style: TextStyle(
                height: 1,
                color: selectedAssets.isNotEmpty
                    ? Colors.white
                    : const Color.fromARGB(115, 155, 155, 155),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}

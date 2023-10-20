import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_asset_picker/src/provider/asset_provider.dart';

class SelectedImagePreview extends ConsumerWidget {
  const SelectedImagePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAsset = ref.watch(selectedAssetProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: selectedAsset.isEmpty ? 0 : 80,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: selectedAsset.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              ref
                  .read(selectedAssetProvider.notifier)
                  .selecteAsset(selectedAsset[index]);
            },
            child: SizedBox(
              width: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: AssetEntityImage(
                      selectedAsset[index],
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(80),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 5,
          );
        },
      ),
    );
  }
}

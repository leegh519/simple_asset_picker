import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_asset_picker/src/provider/asset_path_provider.dart';
import 'package:simple_asset_picker/src/provider/asset_provider.dart';
import 'package:simple_asset_picker/src/views/picker.dart';

class PickerAppbar extends ConsumerWidget {
  const PickerAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAssets = ref.watch(selectedAssetProvider);
    final pickerConfig = Picker.pickerConfig;

    return Container(
      width: double.maxFinite,
      height: 50 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(selectedAssets);
                    ref
                        .watch(selectedPathProvider.notifier)
                        .update((state) => state = null);
                  }
                },
                icon: const Icon(Icons.close),
              ),
              const AlbumDropdown(),
            ],
          ),
          // Spacer(),
          Row(
            children: [
              if (selectedAssets.isNotEmpty)
                Text(
                  '${selectedAssets.length}',
                  style: TextStyle(
                    color: pickerConfig.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
              if (selectedAssets.isNotEmpty && pickerConfig.maxAssets != null)
                Text(
                  '/${pickerConfig.maxAssets}',
                  style: TextStyle(
                    color: pickerConfig.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
              if (selectedAssets.isNotEmpty)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(selectedAssets);
                    ref
                        .watch(selectedPathProvider.notifier)
                        .update((state) => state = null);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      '  완료',
                      style: TextStyle(
                        height: 1,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlbumDropdown extends ConsumerStatefulWidget {
  const AlbumDropdown({super.key});

  @override
  ConsumerState<AlbumDropdown> createState() => _AlbumDropdownState();
}

class _AlbumDropdownState extends ConsumerState<AlbumDropdown> {
  // 드롭박스.
  OverlayEntry? _overlayEntry;
  OverlayEntry? _backgroundOverlay;
  final LayerLink _layerLink = LayerLink();

  // 드롭다운 생성.
  void toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _albumListDropdown();
      _backgroundOverlay = _createBackgoundOverlay();
      Overlay.of(context).insert(
        _backgroundOverlay!,
      );
      Overlay.of(context).insert(
        _overlayEntry!,
      );
    } else {
      _overlayEntry?.remove();
      _backgroundOverlay?.remove();
      _backgroundOverlay = null;
      _overlayEntry = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _overlayEntry?.dispose();
    _backgroundOverlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(assetPathProvider);
    final selected = ref.watch(selectedPathProvider);
    return GestureDetector(
      onTap: selected == null ? null : toggleOverlay,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              // 선택값.
              Flexible(
                child: selected == null
                    ? const Text(
                        '전체보기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        textScaler: TextScaler.noScaling,
                      )
                    : Text.rich(
                        TextSpan(
                          text: '${selected.assetPathEntity.name} ',
                          children: [
                            TextSpan(
                              text: '${selected.count}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        textScaler: TextScaler.noScaling,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              // 아이콘.
              const Icon(
                Icons.arrow_drop_down,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createBackgoundOverlay() {
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: toggleOverlay,
          child: Container(
            color: Colors.transparent,
          ),
        );
      },
    );
  }

  // 드롭다운.
  OverlayEntry _albumListDropdown() {
    final album = ref.watch(assetPathProvider)!;
    return OverlayEntry(
      maintainState: true,
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width * 0.6,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, 26),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 38.0 * (album.length + 1),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.06),
                    ),
                    BoxShadow(
                      offset: const Offset(-2, -2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: album.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        ref
                            .watch(selectedPathProvider.notifier)
                            .update((state) => state = album[index]);
                        toggleOverlay();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.transparent,
                        child: Text.rich(
                          TextSpan(
                            text: '${album[index].assetPathEntity.name} ',
                            children: [
                              TextSpan(
                                text: '${album[index].count}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          textScaler: TextScaler.noScaling,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PickerConfig {
  /// 기존에 선택한 사진
  final List<AssetEntity>? selectedAssets;

  /// 최대 선택가능 갯수
  final int? maxAssets;

  /// 한페이지 갯수,
  /// 30이상
  final int pageSize;

  /// Picker Type
  final RequestType requestType;

  /// 그리드 한줄에 보여줄 갯수,
  /// 3이상
  final int gridCount;

  /// 메인 색상
  final Color mainColor;

  /// 테마 밝기
  final Brightness brightness;

  /// 카메라 사용가능 여부,
  /// 카메라 사용기능 아직 구현안됨
  final bool useCamera;

  const PickerConfig({
    this.selectedAssets,
    this.maxAssets,
    this.pageSize = 30,
    this.requestType = RequestType.common,
    this.gridCount = 3,
    this.mainColor = Colors.yellowAccent,
    this.brightness = Brightness.dark,
    this.useCamera = false,
  })  : assert(gridCount >= 3 && gridCount <= 5),
        assert(pageSize >= 30);
}

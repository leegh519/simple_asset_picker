import 'package:photo_manager/photo_manager.dart';

class AssetPath {
  final int count;
  final AssetPathEntity assetPathEntity;

  AssetPath({
    required this.count,
    required this.assetPathEntity,
  });

  AssetPath copyWith({
    int? count,
    AssetPathEntity? assetPathEntity,
  }) {
    return AssetPath(
      count: count ?? this.count,
      assetPathEntity: assetPathEntity ?? this.assetPathEntity,
    );
  }

  @override
  String toString() =>
      'AssetPath(count: $count, assetPathEntity: $assetPathEntity)';
}

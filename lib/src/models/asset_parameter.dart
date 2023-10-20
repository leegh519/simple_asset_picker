class AssetParameter {
  /// Page Number
  final int page;

  /// Page Size
  final int size;

  const AssetParameter({
    this.page = 0,
    this.size = 30,
  });

  AssetParameter copyWith({
    int? page,
    int? size,
  }) {
    return AssetParameter(
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}

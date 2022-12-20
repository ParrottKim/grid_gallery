import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class GalleryModel {
  Uint8List data;
  AssetEntity asset;
  bool isSelected;

  GalleryModel(
      {required this.data, required this.asset, this.isSelected = false});

  GalleryModel copyWith(
      {Uint8List? data, AssetEntity? asset, bool? isSelected}) {
    return GalleryModel(
      data: data ?? this.data,
      asset: asset ?? this.asset,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

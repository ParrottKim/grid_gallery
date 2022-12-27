part of 'grid_gallery.dart';

class GalleryController extends ChangeNotifier {
  final _gridGalleryKey = GlobalKey<_GridGalleryState>();

  List<GalleryModel> _items = [];
  List<GalleryModel> get items => _items;

  List<int> _selectedIndexes = [];
  List<int> get selectedIndexes => _selectedIndexes;

  XFile? _photo;
  XFile? get photo => _photo;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  int? _lastPage;
  int? get lastPage => _lastPage;

  refreshWidget() {
    _gridGalleryKey.currentState?._();
  }

  load() async {
    _lastPage = _currentPage;
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media = await albums[0].getAssetListPaged(
        size: _gridGalleryKey.currentState!.widget.pageSize,
        page: _currentPage,
      );
      List<GalleryModel> temp = [];

      for (var asset in media) {
        final thumbnail =
            await asset.thumbnailDataWithSize(ThumbnailSize(200, 200));
        final data = await asset.file;
        temp.add(
            GalleryModel(thumbnail: thumbnail!, data: data!, asset: asset));
      }
      _items = [..._items, ...temp];
      _currentPage++;
    } else {
      await PhotoManager.requestPermissionExtend();
    }
    refreshWidget();
    notifyListeners();
  }

  getPhoto() async {
    final ImagePicker _picker = ImagePicker();
    _photo = await _picker
        .pickImage(source: ImageSource.camera)
        .then((recordedImage) async {
      if (recordedImage != null) {
        final AssetEntity? asset = await PhotoManager.editor.saveImageWithPath(
          recordedImage.path,
          title: basename(recordedImage.path),
        );
        if (asset != null) {
          final thumbnail =
              await asset.thumbnailDataWithSize(ThumbnailSize(200, 200));
          final data = await asset.file;
          _items = [
            GalleryModel(
                thumbnail: thumbnail!,
                data: data!,
                asset: asset,
                isSelected: true),
            ..._items,
          ];
          _items.removeLast();
          _selectedIndexes = [for (var value in _selectedIndexes) value + 1];
          _selectedIndexes = [..._selectedIndexes, 0];
        }
      }
    });
    refreshWidget();
    notifyListeners();
  }

  toggle({required GalleryModel data}) {
    final index = _items.indexOf(_items
        .where((element) =>
            element.data == data.data && element.asset == data.asset)
        .first);

    _items[index].isSelected = !data.isSelected;

    if (_selectedIndexes.contains(index)) {
      _gridGalleryKey.currentState?.widget.onRemoved?.call(index);
      _selectedIndexes.remove(index);
    } else {
      _gridGalleryKey.currentState?.widget.onAdded?.call(index);
      _selectedIndexes.add(index);
    }
    refreshWidget();
    notifyListeners();
  }

  deselectAll() {
    _items = [for (final value in _items) value.copyWith(isSelected: false)];
    _selectedIndexes.clear();
    refreshWidget();
    notifyListeners();
  }

  refresh() async {
    _items.clear();
    _selectedIndexes.clear();
    _currentPage = 0;
    await load();
    refreshWidget();
    notifyListeners();
  }

  // add(GalleryModel data) {
  //   _items = [data, ..._items];
  //   _selectedIndexes.add(_items.indexOf(data));
  //   refreshWidget();
  //   notifyListeners();
  // }

  remove(GalleryModel data) {
    final index = _items.indexOf(_items
        .where((element) =>
            element.data == data.data && element.asset == data.asset)
        .first);

    _items[index].isSelected = false;
    _selectedIndexes.remove(index);

    refreshWidget();
    notifyListeners();
  }

  // refresh() async {
  //   await fetchNewMedia();
  // }
}

part of 'grid_gallery.dart';

class GalleryController extends ChangeNotifier {
  final _gridGalleryKey = GlobalKey<_GridGalleryState>();

  List<GalleryModel> _items = [];
  List<GalleryModel> get items => _items;

  List<int> _selectedIndexes = [];
  List<int> get selectedIndexes => _selectedIndexes;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  int? _lastPage;
  int? get lastPage => _lastPage;

  fetchNewMedia() async {
    _lastPage = _currentPage;
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(size: 30, page: currentPage);
      List<GalleryModel> temp = [];

      for (var asset in media) {
        final data = await asset.thumbnailDataWithSize(ThumbnailSize(200, 200));
        temp.add(GalleryModel(data: data!, asset: asset));
      }
      _items = [..._items, ...temp];
      _currentPage++;
    } else {
      await PhotoManager.requestPermissionExtend();
    }
    notifyListeners();
  }

  add(GalleryModel data) {
    _items = [..._items, data];
    selectedIndexes.add(_items.indexOf(data));
    notifyListeners();
  }

  toggle(GalleryModel data) {
    _items = [
      for (final value in _items)
        if (value.data == data.data)
          data.copyWith(isSelected: !data.isSelected)
        else
          value,
    ];

    final index = _items.indexOf(_items
        .where((element) =>
            element.data == data.data && element.asset == data.asset)
        .first);

    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
    notifyListeners();
  }

  remove(GalleryModel data) {
    _items = [
      for (final value in _items)
        if (value.data != data.data) data,
    ];
    notifyListeners();
  }

  refresh() async {
    _items = [];
    await fetchNewMedia();
    notifyListeners();
  }
}

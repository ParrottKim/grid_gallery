import 'package:flutter/material.dart';
import 'package:grid_gallery/src/callback/callback.dart';
import 'package:grid_gallery/src/model/gallery_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

part 'gallery_controller.dart';

class GridGallery extends StatefulWidget {
  GridGallery({
    GalleryController? controller,
    this.crossAxisCount = 3,
    this.videoIcon = const Icon(
      Icons.videocam,
      color: Colors.white,
    ),
    this.videoIconAlign = Alignment.bottomRight,
    this.isCameraSupported = true,
    this.cameraIcon = const Icon(
      Icons.camera_alt_outlined,
      color: Colors.white,
      size: 36.0,
    ),
    this.cameraSectionBackgroundColor = Colors.black87,
    this.unselectedCircleSize = 24.0,
    this.unselectedCircleBorderWidth = 2.0,
    this.unselectedBackgroundColor = Colors.transparent,
    this.unselectedBorderColor = Colors.white,
    this.selectedCircleSize = 24.0,
    this.selectedCircleBorderWidth = 2.0,
    selectedBackgroundColor,
    this.selectedBorderColor = Colors.white,
    this.selectedTextStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    this.onChanged,
  })  : controller = controller ?? GalleryController(),
        selectedBackgroundColor =
            selectedBackgroundColor ?? Colors.black.withOpacity(0.4),
        super(key: controller?._gridGalleryKey);

  final GalleryController controller;

  final int crossAxisCount;
  final Icon videoIcon;
  final Alignment videoIconAlign;

  final bool isCameraSupported;
  final Icon cameraIcon;
  final Color cameraSectionBackgroundColor;

  final double unselectedCircleSize;
  final double unselectedCircleBorderWidth;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;

  final double selectedCircleSize;
  final double selectedCircleBorderWidth;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;

  final TextStyle selectedTextStyle;

  final ChangedCallback? onChanged;

  @override
  State<GridGallery> createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  ScrollController scrollController = ScrollController();

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listenController);
    _load();
  }

  @override
  void didUpdateWidget(covariant GridGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
    if (oldWidget.controller.items.length != widget.controller.items.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listenController);
    super.dispose();
  }

  _load() {
    widget.controller.load();
  }

  _toggle({required GalleryModel data}) {
    widget.controller.toggle(data: data);
    widget.onChanged?.call();
  }

  _() {
    setState(() {});
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.7) {
      if (widget.controller.currentPage != widget.controller.lastPage) {
        widget.controller.load();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.isCameraSupported
        ? widget.controller.items.length + 1
        : widget.controller.items.length;

    return RefreshIndicator(
      onRefresh: () async => await _load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return false;
        },
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics()),
          controller: scrollController,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
          ),
          itemBuilder: (context, index) {
            final itemIndex = widget.isCameraSupported ? index - 1 : index;
            if (widget.isCameraSupported && index == 0) {
              return InkWell(
                onTap: () async {},
                child: Ink(
                  color: widget.cameraSectionBackgroundColor,
                  child: widget.cameraIcon,
                ),
              );
            }
            return InkWell(
              onTap: () {
                _toggle(data: widget.controller.items[itemIndex]);
              },
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(
                              widget.controller.items[itemIndex].thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (widget.controller.items[itemIndex].asset.type ==
                      AssetType.video)
                    Align(
                      alignment: widget.videoIconAlign,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: widget.videoIcon,
                      ),
                    ),
                  if (!widget.controller.items[itemIndex].isSelected)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, top: 5.0),
                        child: Container(
                          width: widget.unselectedCircleSize,
                          height: widget.unselectedCircleSize,
                          decoration: BoxDecoration(
                            color: widget.unselectedBackgroundColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.unselectedBorderColor,
                              width: widget.unselectedCircleBorderWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.controller.items[itemIndex].isSelected)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, top: 5.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: widget.selectedCircleSize,
                              height: widget.selectedCircleSize,
                              decoration: BoxDecoration(
                                color: widget.selectedBackgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.8),
                                  width: widget.selectedCircleBorderWidth,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.controller.selectedIndexes.indexOf(itemIndex) + 1}',
                              style: widget.selectedTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

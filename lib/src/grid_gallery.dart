import 'package:flutter/material.dart';
import 'package:grid_gallery/src/model/gallery_model.dart';
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
    this.unselectedCircleSize = 24.0,
    this.unselectedCircleBorderWidth = 2.0,
    this.unselectedBackgroundColor = Colors.transparent,
    this.unselectedBorderColor = Colors.white,
    this.selectedCircleSize = 24.0,
    this.selectedCircleBorderWidth = 2.0,
    this.selectedBackgroundColor = Colors.red,
    this.selectedBorderColor = Colors.white,
  })  : controller = controller ?? GalleryController(),
        super(key: controller?._gridGalleryKey);

  final GalleryController controller;

  final int crossAxisCount;
  final Icon videoIcon;
  final Alignment videoIconAlign;

  final double unselectedCircleSize;
  final double unselectedCircleBorderWidth;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;

  final double selectedCircleSize;
  final double selectedCircleBorderWidth;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;

  @override
  State<GridGallery> createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // widget.controller.fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.7) {
      if (widget.controller.currentPage != widget.controller.lastPage) {
        widget.controller.fetchNewMedia();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Photo'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await widget.controller.refresh(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            _handleScrollEvent(scroll);
            return false;
          },
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics()),
            controller: scrollController,
            itemCount: widget.controller.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () =>
                  widget.controller.toggle(widget.controller.items[index]),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              MemoryImage(widget.controller.items[index].data),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (widget.controller.items[index].asset.type ==
                      AssetType.video)
                    Align(
                      alignment: widget.videoIconAlign,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: widget.videoIcon,
                      ),
                    ),
                  if (!widget.controller.items[index].isSelected)
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
                  if (widget.controller.items[index].isSelected)
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
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.8),
                                  width: widget.selectedCircleBorderWidth,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.controller.selectedIndexes.indexOf(index) + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

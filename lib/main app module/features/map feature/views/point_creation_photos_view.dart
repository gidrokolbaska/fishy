import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';

import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:fishy/reusable%20widgets/green_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:sizer/sizer.dart';

class PhotosBottomSheetPage extends ConsumerStatefulWidget {
  const PhotosBottomSheetPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PhotosBottomSheetPage> createState() =>
      _PhotosBottomSheetPageState();
}

class _PhotosBottomSheetPageState extends ConsumerState<PhotosBottomSheetPage> {
  late final MultiImagePickerController controller;
  @override
  void initState() {
    super.initState();
    controller = MultiImagePickerController(
        maxImages: 10,
        withReadStream: true,
        allowedImageTypes: ['png', 'jpg', 'jpeg'],
        images: ref.read(selectedPhotosListProvider));
  }

  bool updateOnce = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: grayscaleLine,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    context.popRoute();
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    if (controller.hasNoImages) {
                      ref
                          .read(selectedPhotosListProvider.notifier)
                          .ref
                          .invalidateSelf();
                      context.popRoute();
                      return;
                    } else {
                      ref
                          .read(selectedPhotosListProvider.notifier)
                          .update(controller.images);

                      context.popRoute();
                    }
                  },
                  child: const Text('Готово'),
                )
              ],
            ),
          ),
          Flexible(
            child: MultiImagePickerView(
              scrollController: ModalScrollController.of(context),
              controller: controller,
              padding: const EdgeInsets.only(left: 31, right: 31, top: 8.0),
              draggable: false,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 94,
                  childAspectRatio: 1,
                  crossAxisSpacing: 31,
                  mainAxisSpacing: 31),
              itemBuilder: (insideContext, file, deleteCallback) {
                return GestureDetector(
                  onTap: () {
                    // CustomImageProvider2 customImageProvider =
                    //     CustomImageProvider2(
                    //   images: controller.images,
                    //   initialIndex: (controller.images as List).indexOf(file),
                    // );
                    // showImageViewerPager(
                    //   context,
                    //   customImageProvider,
                    //   swipeDismissible: true,
                    //   doubleTapZoomable: true,
                    // );

                    context.pushTransparentRoute(
                      PhotoFullScreenView(
                        file: file,
                        suffixDeffirentiator: '',
                      ),
                    );
                  },
                  child: ListImageItem(
                    file: file,
                    onDelete: deleteCallback,
                    isMouse: false,
                  ),
                );
              },
              addMoreBuilder: (context, pickerCallback) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: pickerCallback,
                    child: Center(
                      child: Text(
                        'Еще',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
              initialContainerBuilder: (context, pickerCallback) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Нет выбранных фотографий',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    GreenButton(
                      buttonSize: Size(70.w, 72),
                      buttonText: 'Выбрать фотографии',
                      onTap: pickerCallback,
                    )
                  ],
                );
              },
              onChange: (p0) {
                if (controller.hasNoImages) {
                  setState(() {
                    updateOnce = false;
                  });
                } else if (!controller.hasNoImages && updateOnce == false) {
                  setState(() {
                    updateOnce = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
      // Stack(
      //   alignment:
      //       controller.hasNoImages ? Alignment.center : Alignment.topCenter,
      //   children: [
      //     Positioned(
      //       top: 8.0,
      //       child: Container(
      //         width: 24,
      //         height: 3,
      //         decoration: BoxDecoration(
      //           color: grayscaleLine,
      //           borderRadius: BorderRadius.circular(4),
      //         ),
      //       ),
      //     ),

      //   ],
      // ),
    );
  }
}

class ListImageItem extends StatelessWidget {
  const ListImageItem(
      {Key? key,
      required this.file,
      required this.onDelete,
      required this.isMouse})
      : super(key: key);

  final ImageFile file;
  final bool isMouse;
  final Function(ImageFile path) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              placeholderBuilder: (context, heroSize, child) {
                return child;
              },
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                return fromHeroContext.widget;
              },
              tag: file.path!,
              child: ImageFileView(
                file: file,
              ),
            ),
          ),
        ),
        //const Positioned.fill(child: AbsorbPointer()),
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            onTap: isMouse
                ? null
                : () {
                    onDelete(file);
                  },
            onTapDown: isMouse
                ? (d) {
                    onDelete(file);
                  }
                : null,
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/close-48.png',
                  package: 'multi_image_picker_view',
                  height: 18,
                  width: 18,
                )),
          ),
        ),
      ],
    );
  }
}

class PhotoFullScreenView extends StatefulWidget {
  const PhotoFullScreenView({
    super.key,
    this.file,
    this.url,
    required this.suffixDeffirentiator,
  });
  final ImageFile? file;
  final String? url;
  final String suffixDeffirentiator;

  @override
  State<PhotoFullScreenView> createState() => _PhotoFullScreenViewState();
}

class _PhotoFullScreenViewState extends State<PhotoFullScreenView>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();
  late AnimationController _animationController;
  Animation<Matrix4>? _doubleTapAnimation;
  double scale = 1;
  void _onInteractionEnd(ScaleEndDetails details) {
    setState(() {
      scale = _transformationController.value.getMaxScaleOnAxis();
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      //backgroundColor: Colors.red,
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.vertical,
      disabled: scale > 1,
      child: Hero(
        tag:
            widget.file?.path ?? '${widget.url!}${widget.suffixDeffirentiator}',
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          return toHeroContext.widget;
        },
        child:
            // widget.file?.path == null
            //     ? CachedNetworkImage(
            //         imageUrl: widget.url!,
            //       )
            //     : Image.file(
            //         File(widget.file!.path!),
            //         fit: BoxFit.cover,
            //       ),

            InteractiveViewer(
          maxScale: 2.0,
          minScale: 1.0,
          onInteractionEnd: _onInteractionEnd,
          transformationController: _transformationController,
          panEnabled: true,
          constrained: true,
          scaleEnabled: true,
          child: GestureDetector(
            onDoubleTap: _handleDoubleTap,
            onDoubleTapDown: _handleDoubleTapDown,
            child: widget.file?.path == null
                ? CachedNetworkImage(
                    imageUrl: widget.url!,
                  )
                : Image.file(
                    File(widget.file!.path!),
                  ),
          ),
        ),
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    _doubleTapAnimation?.removeListener(_animationListener);
    _doubleTapAnimation?.removeStatusListener(_animationStatusListener);
    setState(() {
      scale = _transformationController.value.getMaxScaleOnAxis();
    });

    if (scale < 2.0) {
      // If we are not at a 2x scale yet, zoom in all the way to 2x.
      final position = _doubleTapDetails.localPosition;
      final begin = _transformationController.value;
      final end = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);

      _updateDoubleTapAnimation(begin, end);
      _animationController.forward(from: 0.0);
    } else {
      // If we are zoomed in at 2x or more, zoom all the way out
      final begin = Matrix4.identity();
      final end = _transformationController.value;

      _updateDoubleTapAnimation(begin, end);

      _animationController.reverse(from: scale - 1.0);
    }
  }

  void _updateDoubleTapAnimation(Matrix4 begin, Matrix4 end) {
    _doubleTapAnimation = Matrix4Tween(begin: begin, end: end).animate(
        CurveTween(curve: Curves.easeInOut).animate(_animationController));
    _doubleTapAnimation?.addListener(_animationListener);
    _doubleTapAnimation?.addStatusListener(_animationStatusListener);
  }

  void _animationListener() {
    _transformationController.value =
        _doubleTapAnimation?.value ?? Matrix4.identity();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      setState(() {
        scale = _transformationController.value.getMaxScaleOnAxis();
      });

      // if (widget.onScaleChanged != null) {
      //   widget.onScaleChanged!(scale);
      // }
    }
  }
}

// class CustomImageProvider2 extends EasyImageProvider {
//   @override
//   final int initialIndex;
//   final Iterable<ImageFile> images;

//   CustomImageProvider2({required this.images, this.initialIndex = 0}) : super();

//   @override
//   ImageProvider<Object> imageBuilder(BuildContext context, int index) {
//     return FileImage(File(images.elementAt(index).path!));
//   }

//   @override
//   int get imageCount => images.length;
// }

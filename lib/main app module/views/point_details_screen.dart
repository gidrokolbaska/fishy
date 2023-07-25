import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:fishy/api/database/firestore_service.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_photos_view.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_edit_main_view.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/attribution_widget.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/current_points_layer.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/point_edit_body.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/top_control_edit_widget.dart';
import 'package:fishy/models/fishy_point_model.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:pull_down_button/pull_down_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class PointDetailsScreen extends ConsumerWidget {
  const PointDetailsScreen({
    super.key,
    required this.pointSnapshot,
  });

  final QueryDocumentSnapshot<PointModel> pointSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot<PointModel>?>(
      initialData: pointSnapshot,
      stream: pointSnapshot.reference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('gabella');
          return const Center(child: Text('Что-то пошло не так'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        final PointModel? point = snapshot.data?.data();
        if (point != null) {
          return CupertinoScaffold(
            body: DraggableHome(
              bodyMainAxisAlignment: MainAxisAlignment.start,
              bodyCrossAxisAlignment: CrossAxisAlignment.start,
              appBarColor: primaryColor,
              alwaysShowLeadingAndAction: true,
              leadingBuilder: (isScrolled) {
                return IconButton(
                  icon: const Icon(
                    FishyIcons.chevron_back,
                    size: 30,
                  ),
                  color: isScrolled ? grayscaleOffwhite : grayscaleOffBlack,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () {
                    context.router.pop();
                  },
                );
              },
              trailingBuilder: (isScrolled) {
                return [
                  PullDownButton(
                    itemBuilder: (context) {
                      return [
                        PullDownMenuItem(
                          onTap: () async {
                            await CupertinoScaffold
                                .showCupertinoModalBottomSheet<void>(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              shadow:
                                  const BoxShadow(color: Colors.transparent),
                              builder: (context) => PointEditMain(
                                topControl: (AnimationController controller) {
                                  return TopControlEditWidget(
                                    point: point,
                                    data: snapshot.data,
                                    controller: controller,
                                  );
                                },
                                child: (AnimationController controller) {
                                  return PointEditBody(
                                    controller: controller,
                                    point: point,
                                  );
                                },
                              ),
                            );
                            // context.pushRoute(
                            //   PointCreationMainRoute(
                            //     child: (controller) {
                            //       return PointCreationBody(
                            //         controller: controller,
                            //       );
                            //     },
                            //     topControl: (controller) {
                            //       return TopControlWidget(
                            //         point:
                            //             LatLng(point.latitude, point.longitude),
                            //         controller: controller,
                            //       );
                            //     },
                            //   ),
                            // );
                          },
                          title: 'Редактировать',
                          icon: FishyIcons.edit,
                        ),
                        PullDownMenuItem(
                          onTap: () {
                            ref.read(firestoreServiceProvider).markAsFavorite(
                                snapshot.data!.reference, !point.isFavorite);
                          },
                          title: point.isFavorite
                              ? 'Удалить из избранного'
                              : 'В избранное',
                          icon: FishyIcons.star,
                        ),
                        const PullDownMenuDivider(),
                        PullDownMenuItem(
                          onTap: () async {
                            ref
                                .read(firestoreServiceProvider)
                                .deletePoint(pointSnapshot, context);
                          },
                          title: 'Удалить',
                          isDestructive: true,
                          icon: FishyIcons.delete,
                        ),
                      ];
                    },
                    buttonBuilder: (context, showMenu) {
                      return IconButton(
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          size: 30,
                        ),
                        color:
                            isScrolled ? grayscaleOffwhite : grayscaleOffBlack,
                        tooltip:
                            MaterialLocalizations.of(context).moreButtonTooltip,
                        onPressed: showMenu,
                      );
                    },
                  ),
                ];
              },
              title: Text(
                'Просмотр позиции',
                style: TextStyle(
                  color: grayscaleOffwhite,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerExpandedHeight: 0.17,
              headerWidget: FlutterMap(
                options: MapOptions(
                  enableScrollWheel: false,
                  interactiveFlags: InteractiveFlag.none,
                  center: LatLng(
                    point.latitude,
                    point.longitude,
                  ),
                  zoom: 18,
                ),
                nonRotatedChildren: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: CustomSimpleAttributionWidget(
                      backgroundColor: const Color(0xCCFFFFFF),
                      source: const Text(
                        '© OpenStreetMap',
                        style: TextStyle(
                          color: Color(0xFF0078a8),
                        ),
                      ),
                      onTap: () {
                        final Uri url = Uri.parse(
                            'https://www.openstreetmap.org/copyright');
                        launchUrl(url);
                      },
                    ),
                  ),
                  // AttributionWidget(
                  //   alignment: Alignment.bottomRight,
                  //   attributionBuilder: (context) {
                  //     return Padding(
                  //       padding: const EdgeInsets.only(bottom: 20.0),
                  //       child: ColoredBox(
                  //         color: const Color(0xCCFFFFFF),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             final Uri url = Uri.parse(
                  //                 'https://www.openstreetmap.org/copyright');
                  //             launchUrl(url);
                  //           },
                  //           child: const Padding(
                  //             padding: EdgeInsets.all(3),
                  //             child: Text(
                  //               '© OpenStreetMap',
                  //               style: TextStyle(color: Color(0xFF0078a8)),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    tileProvider: FMTC.instance('fishyStore').getTileProvider(),
                    userAgentPackageName: 'com.gidrokolbaska.fishy',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          point.latitude,
                          point.longitude,
                        ),
                        width: 46.69,
                        height: 62,
                        anchorPos: AnchorPos.align(AnchorAlign.top),
                        builder: (context) => FishyMarker(
                          colorIndex: point.markerColor,
                          iconIndex: point.markerIcon,
                        ),
                      )
                    ],
                  )
                ],
              ),
              body: [
                ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    point.isFavorite
                        ? Row(
                            children: [
                              const Icon(
                                FishyIcons.star,
                                color: yellow400,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                point.positionName,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                            ],
                          )
                        : Text(
                            point.positionName,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                    const SizedBox(
                      height: 11,
                    ),
                    Row(
                      children: [
                        Icon(
                          FishyIcons.gps,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text:
                                        '${point.latitude},${point.longitude}'))
                                .then(
                              (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Координаты скопированы"),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Text(
                              '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 49,
                    ),
                    Text(
                      'Описание',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    point.positionDescription != null
                        ? Text(
                            point.positionDescription!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                          )
                        : Text(
                            '—',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 15,
                                ),
                          ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Фотографии',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    point.photoURLs != null
                        ? SizedBox(
                            height: 94,
                            child: OverflowBox(
                              maxWidth: MediaQuery.of(context).size.width,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(left: 19.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: point.photoURLs!.length,
                                itemBuilder: (context, index) {
                                  final photo = point.photoURLs![index];
                                  return CachedNetworkImage(
                                    imageUrl: photo,
                                    fit: BoxFit.fill,
                                    imageBuilder: (context, imageProvider) {
                                      return GestureDetector(
                                        onTap: () {
                                          context.pushTransparentRoute(
                                            PhotoFullScreenView(
                                              url: photo,
                                              suffixDeffirentiator:
                                                  '_pointDetails',
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: '${photo}_pointDetails',
                                          placeholderBuilder:
                                              (context, heroSize, child) {
                                            return child;
                                          },
                                          flightShuttleBuilder: (flightContext,
                                              animation,
                                              flightDirection,
                                              fromHeroContext,
                                              toHeroContext) {
                                            return fromHeroContext.widget;
                                          },
                                          child: Container(
                                            height: 94,
                                            width: 94,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder: (context, url) => DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                            .withOpacity(0.5),
                                      ),
                                    )
                                        .animate(
                                            onPlay: (controller) =>
                                                controller.repeat())
                                        .shimmer(
                                          delay: const Duration(seconds: 2),
                                          duration: const Duration(seconds: 1),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    width: 11.0,
                                  );
                                },
                              ),
                            ),
                          )
                        : Text(
                            '—',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 15,
                                ),
                          ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Дата рыбалки',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FishyIcons.calendar,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy', Intl.systemLocale)
                              .format(point.dateOfFishing.toDate()),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Глубина',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FishyIcons.depth,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        point.depth != null
                            //TODO: не забыть сюда локализацию для глубины
                            ? Text(
                                '${point.depth} м',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 13,
                                    ),
                              )
                            : Text(
                                '—',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 15,
                                    ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Вид ловли',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FishyIcons.fishingrod_1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        point.typeOfFishing.isNotEmpty
                            ? Text(
                                point.typeOfFishing.join(', '),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 13,
                                    ),
                              )
                            : Text(
                                '—',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 15,
                                    ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Тип локации',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FishyIcons.filled_location,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        point.typeOfLocation.isNotEmpty
                            ? Text(
                                point.typeOfLocation.join(', '),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 13,
                                    ),
                              )
                            : Text(
                                '—',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 15,
                                    ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Вид дна',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FishyIcons.depth_type,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        point.typeOfDepth.isNotEmpty
                            ? Text(
                                point.typeOfDepth.join(', '),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 13,
                                    ),
                              )
                            : Text(
                                '—',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 15,
                                    ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'Время суток',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        point.isDay
                            ? Icon(
                                Icons.wb_sunny_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : Icon(
                                Icons.nights_stay_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        const SizedBox(
                          width: 11,
                        ),
                        Text(
                          point.isDay ? 'День' : 'Ночь',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                              ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        } else {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()));
        }
      },
    );

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         pinned: true,
    //         stretch: true,
    //         expandedHeight: 250,
    //         backgroundColor: primaryColor,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Image.network(
    //             'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       SliverList(
    //         delegate: SliverChildListDelegate(
    //           List.generate(
    //             40,
    //             (index) => ListTile(
    //               title: Text('Title: $index'),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

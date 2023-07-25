import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_photos_view.dart';
import 'package:fishy/models/fishy_point_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:sizer/sizer.dart';

class FishyGalleryScreen extends StatelessWidget {
  const FishyGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<PointModel>(
      query: pointsRef.where(
        'photoURLs',
        isNull: false,
      ),
      builder: (context, snapshot, child) {
        if (snapshot.isFetching) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('error ${snapshot.error}'),
          );
        }
        if (snapshot.docs.isEmpty) {
          return Center(
            child: Text(
              'Еще не добавлено ни одной фотографии',
              style: TextStyle(
                color: grayscaleBody,
                fontSize: 11.sp,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        // return GroupedListView.grid(
        //   items: snapshot.docs,
        //   itemGrouper: (QueryDocumentSnapshot<PointModel> i) =>
        //       DateUtils.dateOnly(i.data().dateOfFishing.toDate()),
        //   headerBuilder: (context, DateTime datetime) => Padding(
        //     padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
        //     child: Align(
        //       alignment: Alignment.centerLeft,
        //       child: Text(
        //         DateUtils.dateOnly(datetime).toString(),
        //         style: TextStyle(
        //           fontSize: 12.sp,
        //           color: Theme.of(context).colorScheme.onSurface,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        //   gridItemBuilder: (context,
        //       int countInGroup,
        //       int itemIndexInGroup,
        //       QueryDocumentSnapshot<PointModel> item,
        //       int itemIndexInOriginalList) {
        //     return Container(
        //       // width: 150,
        //       // height: 150,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         color: Colors.blue,
        //         borderRadius: BorderRadius.circular(
        //           10,
        //         ),
        //       ),
        //       //padding: const EdgeInsets.all(8),
        //       child: Text(item.data().photoURLs?.length.toString() ?? 'zhopa',
        //           textAlign: TextAlign.center),
        //     );
        //   },
        //   crossAxisCount: 3,
        //   mainAxisSpacing: 10,
        //   padding: const EdgeInsets.all(16.0),
        //   crossAxisSpacing: 10,
        //   itemsAspectRatio: 1,
        // );

        return GroupedListView<QueryDocumentSnapshot<PointModel>, DateTime>(
          elements: snapshot.docs,
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          groupBy: (element) => DateUtils.dateOnly(
            element.data().dateOfFishing.toDate(),
          ),
          groupSeparatorBuilder: (DateTime groupByValue) => Text(
            DateFormat(
              DateFormat.YEAR_ABBR_MONTH_DAY,
              Platform.localeName,
            ).format(groupByValue),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(context).textTheme.bodyLarge!.color!,
              fontWeight: FontWeight.bold,
            ),
          ),
          separator: const SizedBox(
            height: 10,
          ),
          itemBuilder: (context, element) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: element.data().photoURLs!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 194,
              ),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: element.data().photoURLs![index],
                  fit: BoxFit.fill,
                  imageBuilder: (context, imageProvider) {
                    return GestureDetector(
                      onTap: () {
                        context.pushTransparentRoute(
                          PhotoFullScreenView(
                            url: element.data().photoURLs![index],
                            suffixDeffirentiator: '_gallery',
                          ),
                        );
                      },
                      child: Hero(
                        tag: '${element.data().photoURLs![index]}_gallery',
                        placeholderBuilder: (context, heroSize, child) {
                          return child;
                        },
                        flightShuttleBuilder: (flightContext, animation,
                            flightDirection, fromHeroContext, toHeroContext) {
                          return fromHeroContext.widget;
                        },
                        child: Container(
                          // height: 94,
                          // width: 94,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(20),
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
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        delay: const Duration(seconds: 2),
                        duration: const Duration(seconds: 1),
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
            );
          },
          // itemComparator: (item1, item2) =>
          //     item1['name'].compareTo(item2['name']), // optional
          useStickyGroupSeparators: false, // optional

          floatingHeader: false, // optional
          order: GroupedListOrder.DESC, // optional
        );
      },
    );
  }
}

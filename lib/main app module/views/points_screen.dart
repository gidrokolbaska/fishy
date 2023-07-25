import 'package:auto_route/auto_route.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fishy/api/database/firestore_service.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import '../../models/fishy_point_model.dart';

enum FishyPointsFilter {
  all,
  favorite,
}

class FishyPointsScreen extends ConsumerStatefulWidget {
  const FishyPointsScreen({super.key});

  @override
  ConsumerState<FishyPointsScreen> createState() => _FishyPointsScreenState();
}

class _FishyPointsScreenState extends ConsumerState<FishyPointsScreen> {
  FishyPointsFilter _selectedSegment = FishyPointsFilter.all;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 32, right: 32),
          child: CupertinoSlidingSegmentedControl(
            //padding: EdgeInsets.zero,
            children: const {
              FishyPointsFilter.all: Text('Все'),
              FishyPointsFilter.favorite: Text('Избранные'),
            },
            groupValue: _selectedSegment,
            onValueChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SlidableAutoCloseBehavior(
              key: ValueKey<FishyPointsFilter>(_selectedSegment),
              child: FirestoreListView(
                query: _selectedSegment == FishyPointsFilter.all
                    ? pointsRef
                    : pointsRef.where('isFavorite', isEqualTo: true),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                emptyBuilder: (context) {
                  return Center(
                    child: Text(
                      'Еще не добавлено ни одного места улова',
                      style: TextStyle(
                        color: grayscaleBody,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemBuilder: (context, doc) {
                  PointModel point = doc.data();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Material(
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.4),
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            point.isFavorite
                                ? CustomSlidableAction(
                                    padding: const EdgeInsets.all(6),
                                    onPressed: (context) {
                                      ref
                                          .read(firestoreServiceProvider)
                                          .markAsFavorite(
                                              doc.reference, !point.isFavorite);
                                    },
                                    backgroundColor: secondaryDefault,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FishyIcons.star,
                                          color: yellow400,
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            child: Text(
                                              'Удалить из\nизбранного',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SlidableAction(
                                    padding: EdgeInsets.zero,
                                    onPressed: (context) {
                                      ref
                                          .read(firestoreServiceProvider)
                                          .markAsFavorite(
                                              doc.reference, !point.isFavorite);
                                    },
                                    backgroundColor: secondaryDefault,
                                    foregroundColor: Colors.white,
                                    icon: FishyIcons.star,
                                    label: 'В избранное',
                                  ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                ref
                                    .read(firestoreServiceProvider)
                                    .deletePoint(doc, context);
                              },
                              backgroundColor: red500,
                              foregroundColor: Colors.white,
                              icon: FishyIcons.delete,
                              label: 'Удалить',
                            ),
                          ],
                        ),
                        groupTag: 0,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          title: Text(
                            point.positionName,
                            style: TextStyle(
                              color: grayscaleOffBlack,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Шир.: ${point.latitude.toStringAsFixed(4)}, Дол.: ${point.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              color: grayscalePlacehold,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          tileColor: grayscaleOffwhite,
                          onTap: () {
                            context.pushRoute(
                              PointDetailsScreenRoute(pointSnapshot: doc),
                            );
                          },
                          onLongPress: () {},
                          trailing: const Icon(
                            FishyIcons.chevron_forward,
                            color: grayscaleOffBlack,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

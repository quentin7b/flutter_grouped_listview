// Copyright 2022 Quentin KLEIN. All rights reserved.
// Use of this source code is governed by a the MIT license that can be
// found in the LICENSE file.

import "package:collection/collection.dart";
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// GroupedListView Widget
///
class GroupedListView<H, I> extends StatelessWidget {
  // Needed items
  /// List of the items you want to display grouped
  final List<I> items;

  /// Special [Widget] builder taking a [BuildContext] and a [H] header
  /// ([H] is defined by you in the [itemGrouper] parameter)
  /// This *must* be null if you pass a [customBuilder] parameter.
  final Widget Function(BuildContext context, H header)? headerBuilder;

  /// Special [Widget] builder taking a [BuildContext] and a [List] of [I] items
  /// This *must* be null if you pass a [customBuilder] parameter.
  final Widget Function(BuildContext context, List<I> items)? itemsBuilder;

  /// Special [Function] that takes a [I] and returns a [H].
  /// This function is used to create the groups of items.
  final H Function(I item) itemGrouper;

  /// Optional [Function] that helps sort the groups by comparing the [H] headers.
  final Comparator<H>? headerSorter;

  /// Special [Widget] builder taking a [BuildContext], a [H] header and a [List] of [I] items.
  /// This *must* be null if you pass a [headerBuilder] and a [itemsBuilder] parameters.
  final Widget Function(BuildContext context, H header, List<I> items)?
      customBuilder;

  // Optional items for macro ListView

  /// Defines the scroll direction of the [ListView]
  /// By default, it is [Axis.vertical]
  final Axis scrollDirection;

  /// Defines if the [ListView] is reversed or not
  /// By default, it is false
  final bool reverse;

  /// Defines a specific [ScrollController] for the [ListView]
  final ScrollController? controller;

  final bool? primary;

  /// Defines a specific [ScrollPhysics] for the [ListView]
  final ScrollPhysics? physics;

  /// Defines if the [ListView] is shrinked
  /// By default, it is true
  final bool shrinkWrap;

  /// Defines an optional [EdgeInsetsGeometry] padding for the [ListView]
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  // Optional items for nesteed Column

  /// Only used If you are not using a [customBuilder]
  /// Set the [MainAxisAlignment] of the [Column] used to display the [H] header and its [List] of [I] items
  /// By default, it is [MainAxisAlignment.start]
  final MainAxisAlignment itemsMainAxisAlignment;

  /// Only used If you are not using a [customBuilder]
  /// Set the [MainAxisSize] of the [Column] used to display the [H] header and its [List] of [I] items
  /// By default, it is [MainAxisSize.max]
  final MainAxisSize itemsMainAxisSize;

  /// Only used If you are not using a [customBuilder]
  /// Set the [CrossAxisAlignment] of the [Column] used to display the [H] header and its [List] of [I] items
  /// By default, it is [CrossAxisAlignment.center]
  final CrossAxisAlignment itemsCrossAxisAlignment;

  /// Only used If you are not using a [customBuilder]
  /// Set the [TextDirection] of the [Column] used to display the [H] header and its [List] of [I] items
  final TextDirection? itemsTextDirection;

  /// Only used If you are not using a [customBuilder]
  /// Set the [VerticalDirection] of the [Column] used to display the [H] header and its [List] of [I] items
  final VerticalDirection itemsVerticalDirection;

  /// Only used If you are not using a [customBuilder]
  /// Set the [TextBaseline] of the [Column] used to display the [H] header and its [List] of [I] items
  final TextBaseline? itemsTextBaseline;

  /// Created a [GroupedListView] with all the customized parametes you want
  ///
  /// Using this constructor, you'll have to provide the [itemsBuilder]
  /// which is a [Function] that helps build the the List of items.
  ///
  /// Be aware, if you want to build a fully customized header + List item, you
  /// can provide a [customBuilder], but if you do so, let [headerBuilder] and
  /// [itemsBuilder] to null.
  ///
  /// Also, as by default, a [ListView] is used, you can customise it using all
  /// the parameters you need (see [ListView]'s documentation)
  ///
  /// Last but not least, if you do not provide a [customBuilder], you can customise
  /// the default [Column] used to display the [H] headers and [List] of [I] items.
  /// All of the fields are prefixed by `items` ([itemsMainAxisAlignment], [itemsMainAxisSize], ...)
  GroupedListView(
      {Key? key,
      // GroupedListView params
      required this.items,
      this.headerBuilder,
      this.itemsBuilder,
      required this.itemGrouper,
      this.customBuilder,
      this.headerSorter,
      // ListView Params
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = true,
      this.padding,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.restorationId,
      this.clipBehavior = Clip.hardEdge,
      // Column params (not compatible with customBuilder)
      this.itemsMainAxisAlignment = MainAxisAlignment.start,
      this.itemsMainAxisSize = MainAxisSize.max,
      this.itemsCrossAxisAlignment = CrossAxisAlignment.center,
      this.itemsTextDirection,
      this.itemsVerticalDirection = VerticalDirection.down,
      this.itemsTextBaseline})
      : super(key: key) {
    if (customBuilder != null &&
        (headerBuilder != null || itemsBuilder != null)) {
      throw ArgumentError.value(customBuilder,
          'If customBuilder is specified, you should not pass any headerBuilder or itemsBuilder');
    } else if (customBuilder == null && headerBuilder == null) {
      throw ArgumentError.value(headerBuilder,
          'You must provide a non null headerBuilder as there is no customBuilder provided');
    } else if (customBuilder == null && itemsBuilder == null) {
      throw ArgumentError.value(itemsBuilder,
          'You must provide a non null itemsBuilder as there is no customBuilder provided');
    }
  }

  /// Created a [GroupedListView] with your [List] of [I] displayed in a [ListView]
  ///
  /// Using this constructor, you'll have to provide the [listItemBuilder]
  /// which is a [Function] that helps build the the List of items.
  ///
  /// Also, as by default, a [ListView] is used, you can customise it using all
  /// the parameters you need (see [ListView]'s documentation)
  ///
  /// Last but not least, if you do not provide a [customBuilder], you can customise
  /// the default [Column] used to display the [H] headers and [List] of [I] items.
  /// All of the fields are prefixed by `items` ([itemsMainAxisAlignment], [itemsMainAxisSize], ...)
  GroupedListView.list({
    Key? key,
    // GroupedListView params
    required List<I> items,
    required Widget Function(BuildContext context, H header) headerBuilder,
    required Widget Function(BuildContext context, int itemCountInGroup,
            int itemIndexInGroup, I item)
        listItemBuilder,
    required H Function(I item) itemGrouper,
    Comparator<H>? headerSorter,
    // Optional items for macro ListView
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : this(
          key: key,
          // GroupedListView params
          items: items,
          headerBuilder: headerBuilder,
          itemsBuilder: (context, List<I> items) {
            return ListView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) => listItemBuilder(
                    context, items.length, index, items[index]));
          },
          itemGrouper: itemGrouper,
          headerSorter: headerSorter,
          // Optional items for macro ListView
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Created a [GroupedListView] with your [List] of [I] displayed in a [GridView]
  ///
  /// Using this constructor, you'll have to provide the [gridItemBuilder]
  /// which is a [Function] that helps build the the List of items.
  /// You also have to provide at least a [crossAxisCount] to fix the number of items in the axis.
  ///
  /// If you want more customization of the [GridView] you can (not mandatory) use also
  /// [crossAxisSpacing], [mainAxisSpacing] and [itemsAspectRatio]
  ///
  /// Also, as by default, a [ListView] is used, you can customise it using all
  /// the parameters you need (see [ListView]'s documentation)
  ///
  /// Last but not least, if you do not provide a [customBuilder], you can customise
  /// the default [Column] used to display the [H] headers and [List] of [I] items.
  /// All of the fields are prefixed by `items` ([itemsMainAxisAlignment], [itemsMainAxisSize], ...)
  GroupedListView.grid({
    Key? key,
    // GroupedListView params
    required List<I> items,
    required Widget Function(BuildContext context, H header) headerBuilder,
    required Widget Function(BuildContext context, int itemCountInGroup,
            int itemIndexInGroup, I item)
        gridItemBuilder,
    required H Function(I item) itemGrouper,
    Comparator<H>? headerSorter,
    // Gridview params
    required int crossAxisCount,
    double crossAxisSpacing = 0,
    double mainAxisSpacing = 0,
    double itemsAspectRatio = 1,
    // Optional items for macro ListView
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = true,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : this(
          key: key,
          // GroupedListView params
          items: items,
          headerBuilder: headerBuilder,
          itemsBuilder: (context, List<I> items) {
            return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                childAspectRatio: itemsAspectRatio,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                physics: const NeverScrollableScrollPhysics(),
                children: items
                    .mapIndexed((inex, item) =>
                        gridItemBuilder(context, items.length, inex, item))
                    .toList());
          },
          itemGrouper: itemGrouper,
          headerSorter: headerSorter,
          // Optional items for macro ListView
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  @override
  Widget build(BuildContext context) {
    Map<H, List<I>> groupedItems = groupBy(items, itemGrouper);
    List<H> keys = groupedItems.keys.toList();
    if (headerSorter != null) {
      keys.sort(headerSorter);
    }
    return ListView.builder(
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        itemCount: keys.length,
        itemBuilder: (context, index) {
          H header = keys[index];
          List<I> items = groupedItems[header]!;
          if (customBuilder != null) {
            return customBuilder!(context, header, items);
          } else {
            return Column(
              mainAxisAlignment: itemsMainAxisAlignment,
              mainAxisSize: itemsMainAxisSize,
              crossAxisAlignment: itemsCrossAxisAlignment,
              textDirection: itemsTextDirection,
              verticalDirection: itemsVerticalDirection,
              textBaseline: itemsTextBaseline,
              children: [
                headerBuilder!(context, header),
                itemsBuilder!(context, items)
              ],
            );
          }
        });
  }
}

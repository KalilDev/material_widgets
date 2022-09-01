import 'package:flutter/material.dart';

/// The maximum size between related cards according to MD3 specs
const double kCardSpacing = 8.0;

bool defaultIsGrid(BuildContext context) =>
    MediaQuery.of(context).size.width >= 432;

/// The parameters required to create an [GridView] or an [SliverGrid]
class GridParameters {
  const GridParameters({
    required this.columnCount,
    required this.itemWidth,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  final int columnCount;
  final double itemWidth;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
}

/// Compute the column count and the width of each widget in a card grid.
GridParameters gridParametersForMinWidth(
  double width, {
  double minWidth = 200,
  double crossAxisSpacing = kCardSpacing,
  double mainAxisSpacing = kCardSpacing,
}) {
  final widthForRemaing = width - minWidth;
  final widthForExtra = minWidth + crossAxisSpacing;
  final remainingCount = widthForRemaing / widthForExtra;
  final count = widthForExtra <= 0 ? 1 : 1 + remainingCount.floor();

  final crossAxisCount = count;

  final itemWidth =
      (width - ((crossAxisCount - 1) * crossAxisSpacing)) / crossAxisCount;

  return GridParameters(
    columnCount: crossAxisCount,
    itemWidth: itemWidth,
    crossAxisSpacing: crossAxisSpacing,
    mainAxisSpacing: mainAxisSpacing,
  );
}

/// Compute the column count and the width of each widget in a card grid.
GridParameters gridParametersForColumns(
  double width, {
  int minColumns = 2,
  int maxColumns = 6,
  double minWidth = 400,
  double maxWidth = 1200,
  double crossAxisSpacing = kCardSpacing,
  double mainAxisSpacing = kCardSpacing,
}) {
  final widthDt = maxWidth - minWidth;
  final columnCount =
      (minColumns + (((width - minWidth) / widthDt) * maxColumns).toInt())
          .clamp(minColumns, maxColumns)
          .toInt();
  final crossAxisCount = columnCount;

  final itemWidth =
      (width - ((crossAxisCount - 1) * crossAxisSpacing)) / crossAxisCount;

  return GridParameters(
    columnCount: columnCount,
    itemWidth: itemWidth,
    crossAxisSpacing: crossAxisSpacing,
    mainAxisSpacing: mainAxisSpacing,
  );
}

SliverGridDelegate gridDelegateFromParameters(
  GridParameters parameters, {
  double childAspectRatio = 1.0,
  double? mainAxisExtent,
}) =>
    SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: parameters.columnCount,
      mainAxisSpacing: parameters.mainAxisSpacing,
      crossAxisSpacing: parameters.crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      mainAxisExtent: mainAxisExtent,
    );

SliverGrid sliverGridFromParameters(
  GridParameters parameters, {
  required SliverChildDelegate childDelegate,
  double childAspectRatio = 1.0,
  double? mainAxisExtent,
}) =>
    SliverGrid(
      gridDelegate: gridDelegateFromParameters(
        parameters,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: mainAxisExtent,
      ),
      delegate: childDelegate,
    );

GridView gridViewFromParameters(
  GridParameters parameters, {
  required SliverChildDelegate childDelegate,
  double childAspectRatio = 1.0,
  double? mainAxisExtent,
  EdgeInsetsGeometry? padding,
  Axis scrollDirection = Axis.vertical,
}) =>
    GridView.custom(
      gridDelegate: gridDelegateFromParameters(
        parameters,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: mainAxisExtent,
      ),
      childrenDelegate: childDelegate,
      padding: padding,
      scrollDirection: scrollDirection,
    );

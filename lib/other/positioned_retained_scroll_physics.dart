import 'package:flutter/cupertino.dart';

class PositionRetainedScrollPhysics2 extends ScrollPhysics {
  final bool shouldRetain;
  const PositionRetainedScrollPhysics2({super.parent, this.shouldRetain = true});

  @override
  PositionRetainedScrollPhysics2 applyTo(ScrollPhysics? ancestor) {
    return PositionRetainedScrollPhysics2(
      parent: buildParent(ancestor),
      shouldRetain: shouldRetain,
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    final position = super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );

    final diff = newPosition.maxScrollExtent - oldPosition.maxScrollExtent;

    if (oldPosition.pixels > oldPosition.maxScrollExtent) {
      return diff;
    } else {
      return position;
    }
  }
}
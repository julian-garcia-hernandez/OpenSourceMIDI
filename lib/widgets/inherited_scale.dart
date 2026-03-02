import 'package:flutter/material.dart';

class InheritedScale extends InheritedWidget {
  const InheritedScale({super.key, required this.scale, required super.child});
  final List<int> scale;
  static InheritedScale? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedScale>();
  }

  static InheritedScale of(BuildContext context) {
    final InheritedScale? result = maybeOf(context);
    assert(result != null, 'No InheritedScale found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedScale oldWidget) => scale != oldWidget.scale;
}
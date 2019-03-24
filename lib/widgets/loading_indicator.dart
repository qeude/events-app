
import 'package:flutter/material.dart';
import 'package:events_app/utils/constants.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final bool visible;

  const LoadingIndicatorWidget({this.visible});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: visible ? opacityVisible : opacityInvisible,
        duration: Duration(milliseconds: defaultAnimationDuration),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
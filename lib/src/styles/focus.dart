import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

/// A focus border creates an animated border around a widget
/// whenever it has the application primary focus.
class FocusBorder extends StatelessWidget {
  /// Creates a focus border.
  const FocusBorder({
    Key? key,
    required this.child,
    this.focused = true,
    this.style,
  }) : super(key: key);

  final Widget child;

  /// Whether the border is focused
  final bool focused;

  /// The style of this focus border. If non-null, this
  /// is mescled with [ThemeData.focusThemeData]
  final FocusThemeData? style;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final style = context.theme.focusTheme.copyWith(this.style);
    return AnimatedContainer(
      duration: context.theme.fastAnimationDuration,
      curve: context.theme.animationCurve,
      decoration: BoxDecoration(
        borderRadius: style.borderRadius,
        border: focused
            ? Border.fromBorderSide(style.primaryBorder ?? BorderSide.none)
            : null,
        boxShadow: focused && style.glowFactor != 0 && style.glowColor != null
            ? [
                BoxShadow(
                  offset: Offset(1, 1),
                  color: style.glowColor!,
                  spreadRadius: style.glowFactor!,
                  blurRadius: style.glowFactor! * 2.5,
                ),
                BoxShadow(
                  offset: Offset(-1, -1),
                  color: style.glowColor!,
                  spreadRadius: style.glowFactor!,
                  blurRadius: style.glowFactor! * 2.5,
                ),
                BoxShadow(
                  offset: Offset(-1, 1),
                  color: style.glowColor!,
                  spreadRadius: style.glowFactor!,
                  blurRadius: style.glowFactor! * 2.5,
                ),
                BoxShadow(
                  offset: Offset(1, -1),
                  color: style.glowColor!,
                  spreadRadius: style.glowFactor!,
                  blurRadius: style.glowFactor! * 2.5,
                ),
              ]
            : null,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: style.borderRadius,
          border: focused
              ? Border.fromBorderSide(style.secondaryBorder ?? BorderSide.none)
              : null,
        ),
        child: child,
      ),
    );
  }
}

class FocusThemeData with Diagnosticable {
  final BorderRadius? borderRadius;
  final BorderSide? primaryBorder;
  final BorderSide? secondaryBorder;
  final Color? glowColor;
  final double? glowFactor;

  const FocusThemeData({
    this.borderRadius,
    this.primaryBorder,
    this.secondaryBorder,
    this.glowColor,
    this.glowFactor,
  }) : assert(glowFactor == null || glowFactor >= 0);

  factory FocusThemeData.standard({
    required Color primaryBorderColor,
    required Color secondaryBorderColor,
    required Color glowColor,
  }) {
    return FocusThemeData(
      borderRadius: BorderRadius.zero,
      primaryBorder: BorderSide(width: 2, color: primaryBorderColor),
      secondaryBorder: BorderSide(width: 1, color: secondaryBorderColor),
      glowColor: glowColor,
      glowFactor: 0.0,
    );
  }

  FocusThemeData copyWith(FocusThemeData? other) {
    if (other == null) return this;
    return FocusThemeData(
      primaryBorder: other.primaryBorder ?? primaryBorder,
      secondaryBorder: other.secondaryBorder ?? secondaryBorder,
      borderRadius: other.borderRadius ?? borderRadius,
      glowFactor: other.glowFactor ?? glowFactor,
      glowColor: other.glowColor ?? glowColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BorderSide>(
      'primaryBorder',
      primaryBorder,
      ifNull: 'No primary border',
    ));
    properties.add(DiagnosticsProperty<BorderSide>(
      'secondaryBorder',
      secondaryBorder,
      ifNull: 'No secondary border',
    ));
    properties.add(DiagnosticsProperty<BorderRadius>(
      'borderRadius',
      borderRadius,
      defaultValue: BorderRadius.zero,
    ));
    properties.add(DoubleProperty('glowFactor', glowFactor, defaultValue: 0.0));
    properties.add(ColorProperty(
      'glowColor',
      glowColor,
      defaultValue: Colors.transparent,
    ));
  }
}
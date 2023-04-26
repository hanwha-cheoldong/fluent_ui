import 'package:fluent_ui/fluent_ui.dart';

enum IconButtonMode { tiny, small, large }

class IconButton extends BaseButton {
  const IconButton({
    Key? key,
    required Widget icon,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    VoidCallback? onTapDown,
    VoidCallback? onTapUp,
    FocusNode? focusNode,
    bool autofocus = false,
    ButtonStyle? style,
    this.iconButtonMode,
    bool focusable = true,
  }) : super(
          key: key,
          child: icon,
          focusNode: focusNode,
          autofocus: autofocus,
          onLongPress: onLongPress,
          onPressed: onPressed,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          style: style,
          focusable: focusable,
        );

  final IconButtonMode? iconButtonMode;

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);
    final isIconSmall = SmallIconButton.of(context) != null ||
        iconButtonMode == IconButtonMode.tiny;
    final isSmall = iconButtonMode != null
        ? iconButtonMode != IconButtonMode.large
        : SmallIconButton.of(context) != null;
    return ButtonStyle(
      iconSize: ButtonState.all(isIconSmall ? 11.0 : null),
      padding: ButtonState.all(
          isSmall ? kDefaultButtonPadding : const EdgeInsets.all(8.0)),
      backgroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) {
          return ButtonThemeData.buttonColor(context, states);
        } else {
          return ButtonThemeData.uncheckedInputColor(
            theme,
            states,
            transparentWhenNone: true,
          );
        }
      }),
      foregroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) return theme.resources.textFillColorDisabled;
        return null;
      }),
      shape: ButtonState.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      )),
    );
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ButtonTheme.of(context).iconButtonStyle;
  }
}

class SmallIconButton extends InheritedWidget {
  const SmallIconButton({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static SmallIconButton? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SmallIconButton>();
  }

  @override
  bool updateShouldNotify(SmallIconButton oldWidget) {
    return true;
  }
}

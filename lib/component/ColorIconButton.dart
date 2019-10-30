import 'package:flutter/material.dart';

const double _minButtonSize = 48.0;

class ColorIconButton extends StatefulWidget {
  ColorIconButton(
      {Key key,
      this.iconSize = 24.0,
      this.padding = const EdgeInsets.all(8.0),
      this.alignment = Alignment.center,
      @required this.icon,
      this.color,
      this.highlightColor,
      this.disabledColor,
      @required this.onPressed})
      : assert(iconSize != null),
        assert(padding != null),
        assert(alignment != null),
        assert(icon != null),
        super(key: key);

  final double iconSize;

  final EdgeInsetsGeometry padding;

  final AlignmentGeometry alignment;

  final Widget icon;

  final Color color;

  final Color highlightColor;

  final Color disabledColor;

  final VoidCallback onPressed;

  @override
  _State createState() => _State();
}

class _State extends State<ColorIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _color;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    if (_controller == null) {
      _controller = AnimationController(
        duration: Duration(milliseconds: 100),
        vsync: this,
      );
      _color = ColorTween(
        begin: widget.color ?? Theme.of(context).textTheme.button.color,
        end: widget.highlightColor ??
            Theme.of(context).buttonTheme.colorScheme.primary,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      )..addListener(() {
          setState(() => {});
        });
    }

    Color currentColor =
        widget.disabledColor ?? Theme.of(context).disabledColor;

    Widget result = Semantics(
      button: true,
      enabled: widget.onPressed != null,
      child: Container(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: _minButtonSize, minHeight: _minButtonSize),
          child: Padding(
            padding: widget.padding,
            child: SizedBox(
              height: widget.iconSize,
              width: widget.iconSize,
              child: Align(
                alignment: widget.alignment,
                child: IconTheme.merge(
                    data: IconThemeData(
                      size: widget.iconSize,
                      color: widget.onPressed == null
                          ? currentColor
                          : _color.value,
                    ),
                    child: widget.icon),
              ),
            ),
          ),
        ),
      ),
    );

    return InkResponse(
      onTap: () {
        if (widget.onPressed != null) {
          _controller.reverse();
          widget.onPressed();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (widget.onPressed != null) _controller.forward();
      },
      onTapCancel: () {
        if (widget.onPressed != null) _controller.reverse();
      },
      splashColor: Colors.transparent,
      child: result,
    );
  }
}

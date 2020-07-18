import 'package:flutter/material.dart';

const double _minButtonSize = 48.0;

class ColorTextButton extends StatefulWidget {
  ColorTextButton(this.text,
      {Key key,
      this.fontSize = 13.0,
      this.padding = const EdgeInsets.all(8.0),
      this.alignment = Alignment.center,
      this.color,
      this.highlightColor,
      this.disabledColor,
      @required this.onPressed})
      : assert(fontSize != null),
        assert(padding != null),
        assert(alignment != null),
        assert(text != null),
        super(key: key);

  final double fontSize;

  final EdgeInsetsGeometry padding;

  final AlignmentGeometry alignment;

  final String text;

  final Color color;

  final Color highlightColor;

  final Color disabledColor;

  final VoidCallback onPressed;

  @override
  _State createState() => _State();
}

class _State extends State<ColorTextButton>
    with TickerProviderStateMixin {
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
    double width =
        widget.fontSize * widget.text.length + widget.padding.horizontal;

    Widget result = Semantics(
      button: true,
      enabled: widget.onPressed != null,
      child: Container(
        constraints: new BoxConstraints.expand(
          width: width,
          height: 48,
        ),
        child: Padding(
          padding: widget.padding,
          child: Align(
            alignment: widget.alignment,
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.onPressed == null ? currentColor : _color.value,
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

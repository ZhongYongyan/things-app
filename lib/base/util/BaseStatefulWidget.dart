import 'package:flutter/material.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  State<BaseStatefulWidget> state;
  BuildContext context;

  @override
  createState() => _BaseStatefulWidgetState();

  @protected
  Widget build(BuildContext context);

  void initState() {}

  void dispose() {}
}

class _BaseStatefulWidgetState extends State<BaseStatefulWidget> {
  @override
  void initState() {
    super.initState();
    widget.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    widget.context = context;
    return widget.build(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
}

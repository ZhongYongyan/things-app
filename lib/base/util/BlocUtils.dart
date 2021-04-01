import 'dart:async';

import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'Disposable.dart';
import 'LoggingUtils.dart';

class BlocBase extends Disposable {
  final BuildContext context;
  Store<StoreState> _store;
  StreamController<BlocBase> _controller;

  BlocBase(this.context, Store<StoreState> store) {
    this._store = store;
    this._controller = StreamController<BlocBase>.broadcast();
  }

  void dispatch(dynamic action) {
    return _store.dispatch(action);
  }

  StoreState get state {
    return _store.state;
  }

  Stream<BlocBase> get stream {
    return _controller.stream;
  }

  setModel(VoidCallback fn) {
    assert(fn != null);
    fn();
    _controller.sink.add(this);
  }

  @override
  void dispose() {
    _controller.close();
  }

  NavigatorState get navigate {
    return Navigator.of(context);
  }
}

class _BlocStreamBuilder<Bloc extends BlocBase> extends StatelessWidget {
  const _BlocStreamBuilder({
    Key key,
    @required this.builder,
    @required this.bloc,
  });

  final _BlocWidgetBuilder<Bloc> builder;
  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    Widget child = StreamBuilder<BlocBase>(
        stream: bloc.stream,
        initialData: bloc,
        builder: (BuildContext context, AsyncSnapshot<BlocBase> snapshot) {
          return this.builder(context, bloc);
        });
    return child;
  }
}

typedef _BlocWidgetBuilder<Bloc> = Widget Function(
    BuildContext context,
    Bloc bloc,
    );

class _BlocStateConnector<Bloc extends BlocBase> extends StatelessWidget {
  final _BlocWidgetBuilder builder;
  final StoreConverter<StoreState, Bloc> converter;

  _BlocStateConnector({
    this.converter,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<StoreState, Bloc>(
      converter: (store) {
        return converter(store);
      },
      builder: (BuildContext context, Bloc bloc) {
        return _BlocStreamBuilder(
          bloc: bloc,
          builder: builder,
        );
      },
    );
  }
}

abstract class BlocState<Page extends StatefulWidget, Bloc extends BlocBase>
    extends State<Page> with LoggingMixin {
  Bloc _bloc;

  Bloc get bloc => _bloc;

  @mustCallSuper
  @override
  void dispose() {
    _bloc?.dispose();
    _bloc?._controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocStateConnector(
      converter: (store) {
//        assert(_bloc == null);
        _bloc = createBloc(store);
        return _bloc;
      },
      builder: (context, bloc) {
        return createWidget(context);
      },
    );
  }

  Bloc createBloc(Store<StoreState> store);

  Widget createWidget(BuildContext context);
}

abstract class BlocStatefulWidget<Page extends BlocStatefulWidget<Page, Bloc>,
Bloc extends BlocBase> extends StatefulWidget {
  final BlocState<Page, Bloc> _blocState = _BlocStatefulWidgetState();

  @override
  State createState() {
    return _blocState;
  }

  BuildContext get context => _blocState.context;

  Bloc get bloc => _blocState.bloc;

  Bloc createBloc(Store<StoreState> store);

  Widget createWidget(BuildContext context);
}

class _BlocStatefulWidgetState<Page extends BlocStatefulWidget<Page, Bloc>,
Bloc extends BlocBase> extends BlocState<Page, Bloc> {
  @override
  Bloc createBloc(store) {
    return widget.createBloc(store);
  }

  @override
  Widget createWidget(BuildContext context) {
    return widget.createWidget(context);
  }
}

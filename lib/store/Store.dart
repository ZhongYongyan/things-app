import 'dart:ui';

import 'package:app/packages.dart';
import 'package:app/store/module/App.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/store/module/User.dart';
import 'package:app/util/Result.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

class StoreState extends Persistable {
  AppState app = AppState();
  AuthState auth = AuthState();
  UserState user = UserState();

  @override
  void recoverSnapshot() {
    auth.recoverSnapshot();
  }

  @override
  void saveSnapshot() {
    auth.saveSnapshot();
  }
}

class StoreConfig {
  static Logger _log = Logger('store');
  static Store<StoreState> _store;

  static Store<StoreState> config() {
    if (_store == null) {
      StoreState initState = StoreState();
      initState.recoverSnapshot();

      _store = new Store<StoreState>(combineReducers<StoreState>([_reducer]),
          initialState: initState,
          middleware: [
            LoggingMiddleware(),
            ActionAsyncMiddleware(),
          ]);
    }
    return _store;
  }

  static StoreState _reducer(StoreState state, dynamic action) {
    if (action is ActionHandler<StoreState>) {
      return action(state);
    }
    return state;
  }
}

class LoggingMiddleware
    with LoggingMixin
    implements MiddlewareClass<StoreState> {
  @override
  void call(Store<StoreState> store, dynamic action, NextDispatcher next) {
    log.info('store action: $action');

    next(action);
  }
}

class ActionAsyncMiddleware implements MiddlewareClass<StoreState> {
  @override
  void call(Store<StoreState> store, dynamic action, NextDispatcher next) {
    if (action is ActionAsyncHandler<StoreState>) {
      action(store.state, store.dispatch);
    }
    next(action);
  }
}

typedef Dispatch = void Function(dynamic action);

typedef T ActionHandler<T>(T state);

typedef void ActionAsyncHandler<T>(T state, Dispatch dispatch);

typedef ActionAsyncCallback = void Function(Result result);

import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/App.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/store/module/User.dart';
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

  @override
  void recoverUser() {
    auth.recoverUser();
  }

  @override
  void saveUser() {
    auth.saveUser();
  }
}

class StoreConfig {
  static Logger _log = Logger('store');
  static Store<StoreState> _store;

  static Store<StoreState> config() {
    if (_store == null) {
      StoreState initState = StoreState();
      initState.recoverSnapshot();
      initState.recoverUser();
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

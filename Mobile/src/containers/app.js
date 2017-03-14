import React, {Component} from 'react';
import { Crashlytics } from 'react-native-fabric';
import { createStore, applyMiddleware, combineReducers } from 'redux';
import { Provider } from 'react-redux';
import thunk from 'redux-thunk';
import Promise from 'bluebird'

import { setEndpointBase } from '../actions'
import * as reducers from '../reducers';
import Login from './login';
import AppNavigator from './navigation';

const createStoreWithMiddleware = applyMiddleware(thunk)(createStore);
const reducer = combineReducers(reducers);
const store = createStoreWithMiddleware(reducer);

if (module.hot) {
  module.hot.accept(() => {
    const nextReducers = require('../reducers');
    const nextRootReducer = combineReducers(nextReducers);
    store.replaceReducer(nextRootReducer);
  });
}

export default class App extends Component {
  componentWillMount() {
    // Staging :  https://staging.verisolutions.co/api/mv2/
    // Deployment : https://cloud.verisolutions.co/api/mv2/
    store.dispatch(setEndpointBase('https://cloud.verisolutions.co/api/mv2/'));
  }

  _renderLogin() {
    return <Login />
  }

  render() {
    return (
      <Provider store={store}>
        <Login>
          < AppNavigator />
        </Login>
      </Provider>
    );
  }
}

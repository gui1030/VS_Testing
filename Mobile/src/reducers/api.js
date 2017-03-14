import { handleActions } from 'redux-actions'
import Immutable from 'immutable'

export default reducer = handleActions({
  API_SET_HEADERS: (state, {payload: headers}) => {
    return state.setIn(['endpoint', 'headers'], headers);
  },
  API_SET_HEADER: (state, {payload: header}) => {
    return state.mergeIn(['endpoint', 'headers'], header);
  },
  API_SET_ENDPOINT_BASE: (state, {payload: base}) => {
    return state.setIn(['endpoint', 'base'], base);
  },
  API_REQUEST_COUNT: (state, {payload: delta}) => {
    return state.update('requestCount', count => count + delta)
  }
}, Immutable.fromJS({
  requestCount: 0,
  endpoint: {
    base: null,
    headers: {
      'Content-Type': 'application/vnd.api+json',
      Accept: 'application/vnd.api+json'
    }
  }
}));

import { handleActions } from 'redux-actions'
import Immutable from 'immutable'

export default reducer = handleActions({
  CHART_SET_RANGE: (state, {payload: range}) => {
    return state.setIn(['filters', 'range'], range);
  },
  CHART_SET_METRIC: (state, {payload: metric}) => {
    return state.setIn(['filters', 'metric'], metric);
  },
  CHART_SET_DATA: (state, {payload: {key, data}}) => {
    return state.setIn(['data', key], Immutable.fromJS(data));
  }
}, Immutable.fromJS({
  filters: {
    range: 'day',
    metric: 'temp'
  },
  data: {}
}));

import { createAction } from 'redux-actions';
import { apiFetch } from './api';

const setData = createAction('CHART_SET_DATA');
export const setChartRange = createAction('CHART_SET_RANGE');
export const setChartMetric = createAction('CHART_SET_METRIC');

export const readChart = (source) => {
  return (dispatch) => {
    return dispatch(apiFetch(source))
    .then(json => dispatch(setData({key: source, data: json.data})));
  };
};

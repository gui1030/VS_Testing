import { createAction } from 'redux-actions';
import Promise from 'bluebird';
import url from 'url';

export const setEndpointBase = createAction('API_SET_ENDPOINT_BASE');
export const setHeaders = createAction('API_SET_HEADERS');
export const setHeader = createAction('API_SET_HEADER');
export const setAccessToken = (token) => setHeader({Authorization: `Bearer ${token}`});

const updateRequestCount = createAction('API_REQUEST_COUNT');
const checkResponseStatus = (response) => {
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}

export const apiFetch = (target, options = {}) => {
  return (dispatch, getState) => {
    const endpoint = getState().api.get('endpoint');
    const base = endpoint.get('base');
    const headers = endpoint.get('headers').toJS();

    const fetchUrl = url.resolve(base, target);
    const fetchOptions = {headers, ...options};

    console.log(`Fetching ${fetchUrl}`)

    return Promise.resolve(dispatch(updateRequestCount(1)))
      .then(() => fetch(fetchUrl, fetchOptions))
      .then(checkResponseStatus)
      .then(response => response.json())
      .finally(() => dispatch(updateRequestCount(-1)));
  }
}

import { createAction } from 'redux-actions';
import { apiFetch } from './api';
import url from 'url';

const setResource = createAction('JSONAPI_SET_RESOURCE');
const setCollection = createAction('JSONAPI_SET_COLLECTION');
const setRelationship = createAction('JSONAPI_SET_RELATIONSHIP');
export const clearResource = createAction('JSONAPI_CLEAR_RESOURCE');
export const clearCollection = createAction('JSONAPI_CLEAR_COLLECTION');

export const readResource = (path) => {
  return (dispatch) => {
    return dispatch(apiFetch(path))
    .then(json => dispatch(setResource(json)));
  };
};

export const readCollection = (target, type) => {
  type = type || url.parse(target).pathname;

  return (dispatch) => {
    return dispatch(apiFetch(target))
    .then(json => dispatch(setCollection({...json, type })));
  };
};

export const readCollectionNext = (type) => {
  return (dispatch, getState) => {
    let path = getState().jsonapi.getIn([type, 'links', 'next']);
    return dispatch(readCollection(path, type));
  }
}

export const readRelationship = (resource, relationship) => {
  let target = resource.getIn(['relationships', relationship, 'links', 'related']);
  return (dispatch) => {
    dispatch(apiFetch(target))
    .then(json => dispatch(setRelationship({...json, resource, relationship})))
  }
}

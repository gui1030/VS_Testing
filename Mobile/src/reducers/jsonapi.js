import { handleActions } from 'redux-actions';
import Immutable from 'immutable';

const setResource = (state, resource) => {
  let {type, id} = resource;
  let nextState = state;
  if (!nextState.getIn([type, 'data'])) {
    nextState = nextState.setIn([type, 'data'], Immutable.OrderedMap());
  }
  nextState = nextState.setIn([type, 'data', id], Immutable.fromJS(resource));
  return nextState;
};

const setResources = (state, resources) => {
  return resources.reduce(setResource, state);
};

const setIncluded = (state, included = []) => {
  return included.reduce(setResource, state);
};

const setTypeLinks = (state, type, links) => {
  return state.setIn([type, 'links'], Immutable.fromJS(links));
};

const setRelationship = (state, {type, id}, relationship, data) => {
  return state.setIn(
    [type, 'data', id, 'relationships', relationship, 'data'],
    Immutable.fromJS(data)
  );
};

const setRelationshipLinks = (state, {type, id}, relationship, links) => {
  return state.setIn(
    [type, 'data', id, 'relationships', relationship, 'links'],
    links
  );
};

export default reducer = handleActions({
  JSONAPI_SET_RESOURCE: (state, {payload: {data, included = [] } }) => {
    return included.reduce(setResource, setResource(state, data));
  },
  JSONAPI_CLEAR_RESOURCE: (state, {payload: {type, id}}) => {
    return state.deleteIn([type, 'data', id]);
  },
  JSONAPI_SET_COLLECTION: (
    state,
    {
      payload: {
        type,
        data = [],
        included = [],
        links
      }
    }
  ) => {
    let nextState = setResources(state, data);
    nextState = setIncluded(nextState, included);
    if (links) {
      nextState = setTypeLinks(nextState, type, links)
    }
    return nextState;
  },
  JSONAPI_CLEAR_COLLECTION: (state, {payload: type}) => {
    return state.delete(type);
  },
  JSONAPI_SET_RELATIONSHIP: (
    state,
    {
      payload: {
        resource,
        relationship,
        data,
        included = [],
        links
      }
    }
  ) => {
    let nextState = setIncluded(state, included);
    nextState = setRelationship(nextState, resource, relationship, data)
    if (Array.isArray(data)) {
      nextState = setResources(nextState, data);
    } else {
      nextState = setResource(nextState, data);
    }
    if (links) {
      nextState = setRelationshipLinks(nextState, resource, relationship, links)
    }
    return nextState;
  }
}, Immutable.Map());

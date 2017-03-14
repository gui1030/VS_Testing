import { NavigationExperimental } from 'react-native';
import { handleActions } from 'redux-actions';

const { StateUtils } = NavigationExperimental;

const initialState = {
  index: -1,
  routes: [],
  open: false
}

export default reducer = handleActions({
  NAV_POP: (state) => {
    return {...StateUtils.pop(state), open: false}
  },
  NAV_PUSH: (state, { payload: route }) => {
    return {...StateUtils.push(state, route), open: false}
  },
  NAV_RESET: (state, payload) => {
    return initialState;
  },
  NAV_TOGGLE: (state, { payload: open }) => {
    return {...state, open }
  }
}, initialState)
;

import { createAction } from 'redux-actions';

export const navPop = createAction('NAV_POP')
export const navPush = createAction('NAV_PUSH')
export const navReset = createAction('NAV_RESET')
export const navToggle = createAction('NAV_TOGGLE')

import { handleActions } from 'redux-actions'

export default reducer = handleActions({
  LOGIN_ERROR: (state, { payload: error }) => ({ ...state, error: error }),
  LOGIN_USER: (state, { payload: user }) => ({ ...state, user: user })
}, {
  user: null,
  error: null
})
;

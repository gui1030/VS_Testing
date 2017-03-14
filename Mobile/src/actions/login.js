import { createAction } from 'redux-actions';
import { apiFetch, setAccessToken } from './api';
import { readResource } from './jsonapi';
import { navPush, navReset } from './navigation';
import Promise from 'bluebird';
import Keychain from 'react-native-keychain';

const setError = createAction('LOGIN_ERROR')
const setUser = createAction('LOGIN_USER')

const loginRequest = (username, password) => {
  return apiFetch('oauth/token', {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },body: JSON.stringify({
      grant_type: 'password',
      username: username,
      password: password
    })
  });
}

const navigateHome = (user) => {
  let {type} = user || {}
  switch (type) {
    case "admins": return navPush({key: 'accounts', title: 'Accounts'})
    case "account-users": return (dispatch) => {
      return dispatch(readResource(user.relationships.account.links.related))
      .then((action) => {
        let {
          payload: {
            data: {
              type,
              id,
              attributes: {
                name
              }
            }
          }
        } = action;
        return dispatch(
            navPush({
            key: 'account',
            title: name,
            props: { account: { type, id} }
          })
        )
      })
    }
    case "unit-users": return (dispatch) => {
      return dispatch(readResource(user.relationships.unit.links.related))
      .then(action => {
        let {
          payload: {
            data: {
              type,
              id,
              attributes: {
                name
              }
            }
          }
        } = action;
        return dispatch(
          navPush({
            key: 'unit',
            title: name,
            props: { unit: { type, id} }
          })
        )
      })
    }
  }
}

const storeCredentials = (username, password) => {
  return Keychain.setGenericPassword(username, password)
}

export const login = (username, password) => {
  return (dispatch) => {
    dispatch(setError(null))
    return dispatch(loginRequest(username, password))
    .then(json => dispatch(setAccessToken(json.access_token)))
    .tap(() => storeCredentials(username, password))
    .then(() => dispatch(apiFetch('user')))
    .tap(json => dispatch(navigateHome(json.data)))
    .then(json => dispatch(setUser(json.data)))
    .catch(error => dispatch(setError(error)))
  }
}

export const logout = () => {
  return (dispatch) => {
    return Keychain.resetGenericPassword()
    .then(() => dispatch(setUser(null)))
    .then(() => dispatch(navReset(true)))
  }
}

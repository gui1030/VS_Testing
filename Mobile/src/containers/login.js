import {bindActionCreators} from 'redux';
import Login from '../components/login'
import * as actions from '../actions';
import { connect } from 'react-redux';

export default connect(
  ({login, api}, {children}) => ({login, children, server: api.getIn(['endpoint', 'base'])}),
  (dispatch) => ({
    actions: bindActionCreators(actions, dispatch)
  })
)(Login);

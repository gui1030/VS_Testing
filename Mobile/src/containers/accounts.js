import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Accounts from '../components/accounts';
import * as actions from '../actions';

export default connect(
  ({jsonapi, api }) => ({accounts: jsonapi.get('accounts'), api }),
  (dispatch) => ({ actions: bindActionCreators(actions, dispatch)})
)(Accounts);

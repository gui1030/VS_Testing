import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Account from '../components/account';
import * as actions from '../actions'

export default connect(
  (state, { account: { type, id } }) => {
    const range = state.charts.getIn(['filters', 'range']);
    const account = state.jsonapi.getIn([type, 'data', id]);
    let units = account && account.getIn(['relationships', 'units', 'data']);
    if (units) {
      units = units.map(unit => {
        const {type, id} = unit.toJS();
        return state.jsonapi.getIn([type, 'data', id])
      })
    }
    return {account, units, range};
  },
  (dispatch) => ({ actions: bindActionCreators(actions, dispatch)})
)(Account);

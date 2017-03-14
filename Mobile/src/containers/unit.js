import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Unit from '../components/unit';
import * as actions from '../actions'

export default connect(
  (state, { unit: { type, id } }) => {
    const range = state.charts.getIn(['filters', 'range']);
    const metric = state.charts.getIn(['filters', 'metric']);
    const unit = state.jsonapi.getIn([type, 'data', id]);
    let coolers = unit && unit.getIn(['relationships', 'coolers', 'data']);
    if (coolers) {
      coolers = coolers.map(unit => {
        const {type, id} = unit.toJS();
        return state.jsonapi.getIn([type, 'data', id])
      })
    }
    return {unit, coolers, range, metric};
  },
  (dispatch) => ({ actions: bindActionCreators(actions, dispatch)})
)(Unit);

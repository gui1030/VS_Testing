import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Chart from '../components/chart';
import * as actions from '../actions'

export default connect(
  (state, { source }) => {
    const data = state.charts.getIn(['data', source])
    return { source, data }
  },
  (dispatch) => ({ actions: bindActionCreators(actions, dispatch)})
)(Chart);

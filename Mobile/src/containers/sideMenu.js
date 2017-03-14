import {bindActionCreators} from 'redux';
import SideMenu from '../components/sideMenu';
import * as actions from '../actions';
import { connect } from 'react-redux';

export default connect(
  () => ({}),
  (dispatch) => {
    return { actions: bindActionCreators(actions, dispatch) }
  }
)(SideMenu);

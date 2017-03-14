import {bindActionCreators} from 'redux';
import AppNavigator from '../components/navigation';
import * as actions from '../actions/navigation';
import { connect } from 'react-redux';

export default connect(
  ({navigation}) => ({navigation}),
  (dispatch) => ({
    actions: bindActionCreators(actions, dispatch)
  })
)(AppNavigator);

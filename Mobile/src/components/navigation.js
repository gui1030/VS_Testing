import React, { Component } from 'react';
import {
  NavigationExperimental,
  View,
  Text,
  TouchableOpacity,
  StyleSheet
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import Drawer from 'react-native-drawer';
import Accounts from '../containers/accounts';
import Account from '../containers/account';
import Unit from '../containers/unit';
import SideMenu from '../containers/sideMenu';
import gStyles, {colors} from '../styles';

const { CardStack, Header } = NavigationExperimental;

const styles = StyleSheet.create({
  button: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 10
  },
  background: {
    flex: 1,
    backgroundColor: colors.white
  }
})

export default class extends Component {
  _renderHeader(props) {
    const { actions } = this.props;
    return (
      <Header { ...props }
        onNavigateBack={() => actions.navPop(true)}
        renderRightComponent={this._renderRightComponent.bind(this)}
      />
    )
  }

  _renderRightComponent() {
    const { actions } = this.props;
    return(
      <TouchableOpacity
        style={styles.button}
        onPress={() => actions.navToggle(true)}>
        <Icon name="bars" size={20}/>
      </TouchableOpacity>
    )
  }

  _renderScene(props) {
    const route = props.scene.route;
    switch(route.key) {
      case 'accounts': return this._renderAccounts(route.props);
      case 'account': return this._renderAccount(route.props);
      case 'unit': return this._renderUnit(route.props);
      default: return (
        <View style={gStyles.center}>
          <Text style={gStyles.error}>Invalid Route</Text>
        </View>
      )
    }
  }

  _renderBackground(props) {
    return (
      <View style={styles.background}>
        { this._renderScene(props) }
      </View>
    )
  }

  _renderAccounts() {
    return <Accounts />
  }

  _renderAccount(props) {
    return <Account {...props} />
  }

  _renderUnit(props) {
    return <Unit {...props} />
  }

  render() {
    const { navigation, actions } = this.props;
    return (
      <Drawer
        type='overlay'
        content={<SideMenu />}
        open={navigation.open}
        openDrawerOffset={0.2}
        tapToClose={true}
        onClose={() => actions.navToggle(false)}
      >
        <CardStack
          navigationState={navigation}
          onNavigateBack={() => actions.navPop(true)}
          renderScene={this._renderBackground.bind(this)}
          renderHeader={this._renderHeader.bind(this)}
        />
      </Drawer>
    )
  }
}

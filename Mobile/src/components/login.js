import React, { Component } from 'react';
import {
  View,
  Text,
  TextInput,
  ActivityIndicator,
  Image,
  StyleSheet
} from 'react-native';
import Button from '../components/button';
import Keychain from 'react-native-keychain';
import gStyles, { colors } from '../styles';

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.blue,
    padding: 20
  },
  logo: {
    marginBottom: 20
  },
  error: {
    color: colors.red,
  },
  status: {
    height: 40
  }
})

export default class extends Component {
  constructor() {
   super();
   this.state = {
     email: null,
     password: null,
     loading: false
   };
  }

  componentWillMount() {
    Keychain.getGenericPassword()
    .then(credentials => this.setState({
      email: credentials.username,
      password: credentials.password
    }))
    .then(this._login.bind(this))
    .catch(error => this.setState({email: null, password: null}))
  }

  render() {
    if (!this._currentUser()) {
      return this._renderLoginScreen();
    } else {
      return this.props.children || null
    }
  }

  _login() {
    const { actions } = this.props;
    this.setState({loading: true});
    return actions.login(this.state.email, this.state.password)
    .then(action => {
      if (!action.error) {
        this.setState({ email: null, password: null })
      }
    })
    .finally(() => this.setState({loading: false}))
  }

  _currentUser() {
    return this.props.login.user;
  }

  _renderStatus() {
    const { login: { error } } = this.props;
    if (error) {
      return (
        <Text style={styles.error}>
          {error.message || 'Login Failed'}
        </Text>
      )
    } else if (this.state.loading) {
      return <ActivityIndicator />
    } else {
    }
  }

  _renderServerInput() {
    const { server, actions } = this.props;
    if (!__DEV__) {
      return null;
    }
    return (
      <TextInput
        ref='server'
        value={server}
        onChangeText={(server) => actions.setEndpointBase(server)}
        onSubmitEditing={() => this.refs.email.focus()}
        style={gStyles.input}
        placeholder='Cloud Server'
        autoCapitalize='none'
        autoCorrect={false}
        returnKeyType='next'/>
    )
  }

  _renderLoginScreen() {
    return(
      <View style={styles.wrapper}>
        <Image source={require('../images/logo-white-w-name.png')} style={styles.logo}/>
        { this._renderServerInput() }
        <TextInput
          ref='email'
          value={this.state.email}
          onChangeText={(email) => this.setState({email})}
          onSubmitEditing={() => this.refs.password.focus()}
          style={gStyles.input}
          keyboardType='email-address'
          placeholder='Email Address'
          autoCapitalize='none'
          autoCorrect={false}
          returnKeyType='next'/>
        <TextInput
          ref='password'
          value={this.state.password}
          onChangeText={(password) => this.setState({password})}
          onSubmitEditing={this._login.bind(this)}
          style={gStyles.input}
          placeholder='Password'
          returnKeyType='done'
          secureTextEntry={true}/>
        <Button onPress={this._login.bind(this)} >
          <Text style={styles.textCenter}>Login</Text>
        </Button>
        <View style={styles.status}>
          { this._renderStatus() }
        </View>
      </View>
    )
  }
}

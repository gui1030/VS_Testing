import React, { Component } from 'react';
import { View, Text, ListView, TouchableHighlight, RefreshControl } from 'react-native';
import Immutable from 'immutable';
import styles from '../styles';
import colors from '../styles/colors';

export default class extends Component {
  constructor(props) {
    super(props);
    this.state = {
      dataSource: new ListView.DataSource({rowHasChanged: this._rowHasChanged}),
      refreshing: false
    }
  }

  componentWillMount() {
    this._onRefresh();
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.accounts && !Immutable.is(nextProps.accounts, this.props.accounts)) {
      this._setData(nextProps)
    }
  }

  render() {
    return (
      <ListView
        dataSource={this.state.dataSource}
        refreshControl={this._refreshControl()}
        renderRow={this._renderRow.bind(this)}
        renderSeparator={this._renderSeparator.bind(this)}
        onEndReached={this._onEndReached.bind(this)}/>
    )
  }

  _setData(props) {
    this.setState({
      dataSource: this.state.dataSource.cloneWithRows(props.accounts.get('data').toArray()),
      refreshing: false
    })
  }

  _rowHasChanged(r1, r2) {
    return !Immutable.is(r1, r2);
  }

  _renderRow(account, sectionID, rowID) {
    const onPress = () => this._pressRow(account)
    return (
      <TouchableHighlight
        style={styles.row}
        activeOpacity={1}
        underlayColor={colors.grayLighter}
        onPress={onPress}>
        <Text>{account.getIn(['attributes', 'name'])}</Text>
      </TouchableHighlight>
    )
  }

  _renderSeparator(sectionID, rowID) {
    return (
      <View key={rowID} style={styles.separator}/>
    );
  }

  _pressRow(account) {
    return this._navigateTo(account)
  }

  _navigateTo(account) {
    const { actions } = this.props;
    const { type, id } = account.toJS();
    return actions.navPush({
      key: 'account',
      title: account.getIn(['attributes', 'name']),
      props: { account: { type, id } }
    })
  }

  _refreshControl() {
    return(
      <RefreshControl
        style={styles.refresh}
        refreshing={this.state.refreshing}
        onRefresh={this._onRefresh.bind(this)}
      />
    );
  }

  _onRefresh() {
    const { actions } = this.props;
    this.setState({refreshing: true});
    actions.clearCollection('accounts')
    return actions.readCollection('accounts')
    .then(() => {
      this.setState({refreshing: false})
    });
  }

  _isLoading() {
    return this.props.api.get('requestCount') > 0;
  }

  _hasNone() {
    return this.props.accounts == null;
  }

  _hasMore() {
    const { accounts } = this.props
    return accounts && accounts.getIn(['links', 'next']);
  }

  _onEndReached() {
    if (this._hasMore() && !this._isLoading()) {
      this.props.actions.readCollectionNext('accounts');
    }
  }
}

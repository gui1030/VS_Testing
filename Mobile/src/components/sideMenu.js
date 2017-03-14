import React, { Component } from 'react';
import { View, Text, TouchableHighlight, StyleSheet, Platform } from 'react-native';
import gStyles, {colors} from '../styles'

const styles = StyleSheet.create({
  sidebar: {
    flex: 1,
    backgroundColor: colors.white,
    borderRightWidth: 1,
    borderRightColor: colors.blue
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: colors.grayLight
  }
})

export default class extends Component {
  render() {
    const { actions } = this.props;
    return (
      <View style={styles.sidebar}>
        { this._renderMarginTop()}
        <TouchableHighlight
          style={styles.row}
          activeOpacity={1}
          underlayColor={colors.grayLighter}
          onPress={actions.logout}>
            <Text>Logout</Text>
        </TouchableHighlight>
      </View>
    )
  }

  _renderMarginTop() {
    if (Platform.OS === 'ios') {
      return <View style={styles.row}/>
    }
  }
}

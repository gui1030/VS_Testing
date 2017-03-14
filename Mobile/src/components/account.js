import React, { Component } from 'react';
import {
  View,
  Text,
  TouchableHighlight,
  ActivityIndicator,
  SegmentedControlIOS,
  StyleSheet } from 'react-native';
import Swiper from 'react-native-swiper';
import Immutable from 'immutable';
import url from 'url';
import gStyles, { colors } from '../styles';
import Chart from '../containers/chart';

const styles = StyleSheet.create({
  unitHeader: {
    padding: 10,
    borderBottomWidth: 1,
    borderColor: colors.grayLight,
  },
  center: {
    alignItems: 'center'
  },
});

const ranges = {
  day: 'Day',
  week: 'Week',
  month: 'Month',
  year: 'Year',
}
const rangeKeys = Object.keys(ranges)
const rangeValues = rangeKeys.map(k => ranges[k])

export default class extends Component {
  render() {
    const {account, units, range, actions} = this.props
    return (
      <View style={gStyles.container}>
        <View style={styles.unitHeader}>
          <SegmentedControlIOS
            values={rangeValues}
            selectedIndex={rangeKeys.indexOf(range)}
            onChange={({nativeEvent: {selectedSegmentIndex}}) => {
              actions.setChartRange(rangeKeys[selectedSegmentIndex])
            }}
          />
        </View>
        <View style={[styles.unitHeader, styles.center]}>
          <Text>Compliance (%)</Text>
        </View>
        <View
          style={gStyles.container}
          onLayout={this._onLayout.bind(this)}
        >
          {account && units ? this._renderUnits() : this._renderLoading()}
        </View>
      </View>
    )
  }

  componentWillMount(){
    const { account, units } = this.props;
    if (!account || !units) {
      return this._loadData();
    }
  }

  _renderUnits() {
    const { units } = this.props;
    const { height, width } = this.state || {};
    return (
      <Swiper
        width={width}
        height={height}
        loadMinimal={true}
      >
        { units.map(this._renderUnit.bind(this)).toArray() }
      </Swiper>
    )
  }

  _renderUnit(unit) {
    const { range } = this.props;
    const {
      type,
      id,
      attributes: { name },
      links: { chart }
    } = unit.toJS()
    const source = url.parse(chart)
    source.query = { range }

    return(
      <View key={`${type}-${id}`} style={gStyles.container}>
        <TouchableHighlight
          style={[styles.unitHeader, styles.center]}
          activeOpacity={1}
          underlayColor={colors.grayLighter}
          onPress={() => this._navigateTo(unit)}
        >
          <Text>{name}</Text>
        </TouchableHighlight>
        <View style={gStyles.center}>
          <Chart source={source.format()} />
        </View>
      </View>
    )
  }

  _renderLoading() {
    return (
      <View style={gStyles.center} >
        <ActivityIndicator />
      </View>
    )
  }

  _loadData() {
    const { account, actions } = this.props;
    const { type, id} = account.toJS();
    return actions.readResource(`${type}/${id}?include=units`)
  }

  _navigateTo(unit) {
    const { actions } = this.props;
    const { type, id} = unit.toJS();
    return actions.navPush({
      key: 'unit',
      title: unit.getIn(['attributes', 'name']),
      props: { unit: { type, id } }
    })
  }

  _onLayout({nativeEvent: { layout: {width, height}}}) {
    this.setState({width, height})
  }
}

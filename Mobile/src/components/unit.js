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
  header: {
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

const metrics = {
  temp: 'Temperature',
  humidity: 'Humidity',
  battery: 'Battery'
}
const metricKeys = Object.keys(metrics)
const metricValues = metricKeys.map(k => metrics[k])

export default class extends Component {
  constructor(props) {
    super(props);
    this.state = {
      rangeIndex: 0,
      metricIndex: 0
    }
  }

  render() {
    const {unit, coolers, range, metric, actions} = this.props
    return (
      <View style={gStyles.container}>
        <View style={styles.header}>
          <SegmentedControlIOS
            values={rangeValues}
            selectedIndex={rangeKeys.indexOf(range)}
            onChange={({nativeEvent: {selectedSegmentIndex}}) => {
              actions.setChartRange(rangeKeys[selectedSegmentIndex]);
            }}
          />
        </View>
        <View style={styles.header}>
          <SegmentedControlIOS
            values={metricValues}
            selectedIndex={metricKeys.indexOf(metric)}
            onChange={({nativeEvent: {selectedSegmentIndex}}) => {
              actions.setChartMetric(metricKeys[selectedSegmentIndex]);
            }}
          />
        </View>
        <View
          style={gStyles.container}
          onLayout={this._onLayout.bind(this)}
        >
          {unit && coolers ? this._renderCoolers() : this._renderLoading()}
        </View>
      </View>
    )
  }

  componentWillMount(){
    const { unit, coolers } = this.props;
    if (!unit || !coolers) {
      return this._loadData();
    }
  }

  _renderCoolers() {
    const { coolers } = this.props;
    const { height, width } = this.state;
    return (
      <Swiper
        width={width}
        height={height}
        loadMinimal={true}
      >
        { coolers.map(this._renderCooler.bind(this)).toArray() }
      </Swiper>
    )
  }

  _renderCooler(cooler) {
    const { range, metric } = this.props;
    const {
      type,
      id,
      attributes: { name },
      links: { chart }
    } = cooler.toJS()
    const source = url.parse(chart)
    source.query = { range, metric }

    return(
      <View key={id} style={gStyles.container}>
        <View style={[styles.header, styles.center]} >
          <Text>{name}</Text>
        </View>
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
    const { unit, actions } = this.props;
    const { type, id} = unit.toJS();
    return actions.readResource(`${type}/${id}?include=coolers`)
  }

  _onLayout({nativeEvent: { layout: {width, height}}}) {
    this.setState({width, height})
  }
}

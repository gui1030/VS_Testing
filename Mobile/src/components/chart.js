import React, { Component } from 'react';
import {
  Text,
  ActivityIndicator,
  StyleSheet
} from 'react-native';
import { LineChart } from 'react-native-ios-charts';
import moment from 'moment';
import gStyles, {colors} from '../styles';

const styles = StyleSheet.create({
  chart: {
    flex: 1,
    alignSelf: 'stretch',
    marginBottom: 40,
    backgroundColor: colors.white
  }
})

export default class extends Component {
  componentWillMount() {
    const { data, source, actions } = this.props;
    if (!data) {
      actions.readChart(source)
    }
  }

  componentWillReceiveProps(nextProps) {
    const { data, source, actions } = nextProps;
    if (!data) {
      actions.readChart(source)
    }
  }

  _parseTime(str) {
    return moment(str, 'YYYY-MM-DDTHH:mm:ss.SSSZ', true)
  }

  _formatTime(labels) {
    return labels.map(l => this._parseTime(l).format('l LT'))
  }

  _labels() {
    const { data } = this.props;
    let labels = data.map(d => d.get(0))
    if (this._parseTime(labels.first()).isValid()) {
      labels = this._formatTime(labels)
    }
    return labels.toArray()
  }

  _values() {
    const { data } = this.props;
    return data.map(d => d.get(1)).toArray()
  }

  render() {
    const { data } = this.props;
    if (!data) {
      return <ActivityIndicator />
    } else if (data.count() < 2) {
      return <Text>No Data</Text>
    } else {
      return(
        <LineChart
          style={styles.chart}
          config={{
            dataSets:[{
              values: this._values(),
              colors: [colors.blue],
              label : 'THE DATA',
              circleRadius: 3,
              lineWidth: 2,
              circleColors: [colors.blue],
              drawFilled: true,
              valueTextColor: 'transparent',
            }],
            labels: this._labels(),
            backgroundColor: colors.white,
            gridBackgroundColor: colors.red,
            showLegend: false,
            userInteractionEnabled: false,
            xAxis: {
              position: 'bottom',
              drawGridLines: false,
              drawAxisLine: false,
              textColor: colors.gray,
            },
            rightAxis: {
              enabled: false
            },
            leftAxis: {
              drawAxisLine: false,
              drawGridlines: false,
              textColor: colors.gray,
            },
            valueFormatter: {
              type: 'regular',
              minimumDecimalPlaces: 0,
              maximumDecimalPlaces: 0
            }
          }}
        />
      )
    }
  }
}

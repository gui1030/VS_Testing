import React from 'react';
import { TouchableHighlight, StyleSheet } from 'react-native';
import gStyles, { colors } from '../styles';

const styles = StyleSheet.create({
  button: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'stretch',
    height: 40,
    padding: 10,
    backgroundColor: colors.grayLight,
    borderRadius: 2,
    shadowColor: colors.gray,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 1,
    shadowRadius: 0,
    marginBottom: 10
  }
})

export default Button = (props) => {
  return (
    <TouchableHighlight {...props} style={styles.button} underlayColor={colors.gray} >
      { props.children }
    </TouchableHighlight>
  )
}

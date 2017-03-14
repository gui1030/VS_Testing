import { StyleSheet, Platform } from 'react-native';
import colors from './colors';

export { colors };
export default StyleSheet.create({
  container: {
    flex: 1,
  },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  input: {
    height: 40,
    backgroundColor: colors.white,
    borderColor: colors.grayLight,
    borderWidth: 1,
    borderRadius: 2,
    marginBottom: 10,
    paddingLeft: 10,
    paddingRight: 10
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'center',
    padding: 10
  },
  separator: {
    height: 1,
    backgroundColor: colors.grayLight
  },
  refresh: {
    backgroundColor: colors.grayLight
  }
});

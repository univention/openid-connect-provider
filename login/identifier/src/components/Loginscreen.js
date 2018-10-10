import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import Typography from '@material-ui/core/Typography';
import { Route, Switch } from 'react-router-dom';
import renderIf from 'render-if';

import Login from './Login';
import Chooseaccount from './Chooseaccount';
import Consent from './Consent';
import Loading from './Loading';
import RedirectWithQuery from './RedirectWithQuery';
import UCSLogo from '../images/ucs-logo.svg';
import { executeHello } from '../actions/common-actions';

const styles = theme => ({
  root: {
    display: 'flex',
    flex: 1,
    flexWrap: 'nowrap',
  },
  header: {
    marginTop: theme.spacing.unit * 10,
    marginBottom: theme.spacing.unit * 7,
  },
  limiter: {
    width: 313,
    paddingBottom: theme.spacing.unit * 2,
  },
  [`@media (max-width: ${313 + (theme.spacing.unit * 4)}px)`]: {
    limiter: {
      width: '100%',
      paddingLeft: theme.spacing.unit * 2,
      paddingRight: theme.spacing.unit * 2,
    },
  },
  paper: {
    backgroundColor: 'white',
    minHeight: 313,
    maxHeight: 550,
    display: 'flex',
    flexDirection: 'column',
  },
  logo: {
    width: 120,
    height: 120,
    display: 'block',
    paddingTop: theme.spacing.unit * 7,
    marginLeft: 'auto',
    marginRight: 'auto',
  },
  loadingWrapper: {
    flexGrow: 1,
    position: 'relative',
  },
});

class Loginscreen extends React.PureComponent {
  componentDidMount() {
    this.props.dispatch(executeHello());
  }

  render() {
    const { classes, hello } = this.props;
    return (
      <Grid container direction="column" justify="start" alignItems="center" spacing={0} className={classes.root}>
        <Typography variant="headline" className={classes.header}>Login</Typography>
        <Grid item className={classes.limiter}>
          <Paper className={classes.paper} square elevation={2}>
            <img src={UCSLogo} className={classes.logo} alt="UCS"/>
            {renderIf(hello !== null)(() => (
              <Switch>
                <Route path="/identifier" exact component={Login}></Route>
                <Route path="/chooseaccount" exact component={Chooseaccount}></Route>
                <Route path="/consent" exact component={Consent}></Route>
                <RedirectWithQuery target="/identifier"/>
              </Switch>
            ))}
            {renderIf(hello === null)(() => (
              <div className={classes.loadingWrapper}>
                <Loading/>
              </div>
            ))}
          </Paper>
        </Grid>
      </Grid>
    );
  }
}

Loginscreen.propTypes = {
  classes: PropTypes.object.isRequired,

  hello: PropTypes.object,

  dispatch: PropTypes.func.isRequired
};

const mapStateToProps = (state) => {
  const { hello } = state.common;

  return {
    hello
  };
};

export default connect(mapStateToProps)(withStyles(styles)(Loginscreen));

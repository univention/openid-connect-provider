import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import renderIf from 'render-if';

import Loading from './Loading';
import UCSLogo from '../images/ucs-logo.svg';
import { executeHello, executeLogoff } from '../actions/common-actions';

const styles = theme => ({
  root: {
    display: 'flex',
    flex: 1,
    flexWrap: 'nowrap'
  },
  header: {
    marginTop: theme.spacing.unit * 10,
    marginBottom: theme.spacing.unit * 7
  },
  limiter: {
    width: 313,
    paddingBottom: theme.spacing.unit * 2
  },
  [`@media (max-width: ${313 + (theme.spacing.unit * 4)}px)`]: {
    limiter: {
      width: '100%',
      paddingLeft: theme.spacing.unit * 2,
      paddingRight: theme.spacing.unit * 2
    }
  },
  paper: {
    backgroundColor: 'white',
    minHeight: 313,
    maxHeight: 550,
    display: 'flex',
    flexDirection: 'column'
  },
  logo: {
    width: 120,
    height: 120,
    display: 'block',
    paddingTop: theme.spacing.unit * 7,
    marginLeft: 'auto',
    marginRight: 'auto'
  },
  subHeader: {
    marginBottom: theme.spacing.unit * 5
  },
  wrapper: {
    paddingLeft: theme.spacing.unit * 3,
    paddingRight: theme.spacing.unit * 3,
    paddingTop: theme.spacing.unit * 2,
    paddingBottom: theme.spacing.unit * 2
  },
  loadingWrapper: {
    flexGrow: 1,
    position: 'relative'
  }
});

class Goodbyescreen extends React.PureComponent {
  componentDidMount() {
    this.props.dispatch(executeHello());
  }

  render() {
    const { classes, hello } = this.props;
    return (
      <Grid container direction="column" justify="start" alignItems="center" spacing={0} className={classes.root}>
        <Typography variant="headline" className={classes.header}>&nbsp;</Typography>
        <Grid item className={classes.limiter}>
          <Paper className={classes.paper} elevation={4}>
            <img src={UCSLogo} className={classes.logo} alt="UCS"/>
            {renderIf(hello !== null && !hello.state)(() => (
              <div className={classes.wrapper}>
                <Typography variant="headline" component="h3">
                  Goodbye
                </Typography>
                <Typography variant="subheading" className={classes.subHeader}>
                  you have been signed out from your Kopano account
                </Typography>

                <Typography gutterBottom>
                  You can close this window now.
                </Typography>
              </div>
            ))}
            {renderIf(hello !== null && hello.state === true)(() => (
              <div>
                <Typography variant="headline" component="h3">
                  Hello {hello.displayName}
                </Typography>
                <Typography variant="subheading" className={classes.subHeader}>
                  please confirm sign out
                </Typography>

                <Typography gutterBottom>
                  Press the button below, to sign out from your Kopano account now.
                </Typography>

                <div className={classes.buttonGroup}>
                  <div className={classes.wrapper}>
                    <Button
                      color="secondary"
                      className={classes.button}
                      onClick={(event) => this.logoff(event)}
                    >Sign out</Button>
                  </div>
                </div>
              </div>
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

  logoff(event) {
    event.preventDefault();

    this.props.dispatch(executeLogoff()).then((response) => {
      const { history } = this.props;

      if (response.success) {
        this.props.dispatch(executeHello());
        history.push('/goodbye');
      }
    });
  }
}

Goodbyescreen.propTypes = {
  classes: PropTypes.object.isRequired,

  hello: PropTypes.object,

  dispatch: PropTypes.func.isRequired,
  history: PropTypes.object.isRequired
};

const mapStateToProps = (state) => {
  const { hello } = state.common;

  return {
    hello
  };
};

export default connect(mapStateToProps)(withStyles(styles)(Goodbyescreen));

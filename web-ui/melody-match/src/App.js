import "./App.scss";
import { Container} from "react-bootstrap";
import { Switch, Route } from "react-router-dom";
import { connect } from "react-redux";

import TrackList from "./Tracks/Tracks.js";
import MatchList from "./Matches/List.js"
import Register from "./Session/Register.js";
import Login from "./Session/Login.js"
import EditUser from "./User/Edit.js"
import Chat from "./Lobby/Channel"
import Nav from "./Nav";
import { api_post, fetch_tracks } from "./api";
import { useState, useEffect } from "react";
import store from "./store";


// Get the hash of the url
const hash = window.location.search
  .substring(1)
  .split("&")
  .reduce(function (initial, item) {
    if (item) {
      var parts = item.split("=");
      initial[parts[0]] = decodeURIComponent(parts[1]);
    }
    return initial;
  }, {});
window.location.hash = "";

function App({session}) {
  let _token = hash.code;
  const [state, setState] = useState({
    loggedIn: false,
    token: false,
    tracks: false,
  });
  useEffect(() => {
    if (_token) {
      setState({ loggedIn: false, token: _token, tracks: false });
        let action = {
          type: "spotifyToken/set",
          data: _token
        };
        store.dispatch(action);
        if (session){
          api_post(`/users/${session.user_id}/spotify_token`, {
            auth_code: _token,
            redirect_uri: "https://melody-match.baustin-neu.site",
          },
          session.token);
        }

    }
  }, [_token]);

  let body = (
    <Switch>
      <Route path="/" exact>
        <Chat />
      </Route>
      <Route path="/register" exact>
        <Register />
      </Route>
      <Route path="/tracks" exact>
        <TrackList />
      </Route>
      <Route path="/login" exact>
        <Login />
      </Route>
      <Route path="/matches" exact>
        <MatchList />
      </Route>
      <Route path="/user" exact>
        <EditUser />
      </Route>
    </Switch>
  );
  return (
    <Container fluid>
      <Nav />
      {body}
    </Container>
  );
}

function state2props({ session }) {
  return { session };
}

export default connect(state2props)(App);

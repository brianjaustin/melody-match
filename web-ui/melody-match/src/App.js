import "./App.scss";
import { Container} from "react-bootstrap";
import { Switch, Route } from "react-router-dom";
import { connect } from "react-redux";

import TrackList from "./Tracks/Tracks.js";
import Register from "./Session/Register.js";
import Login from "./Session/Login.js"
import Lobby from "./Lobby/Lobby.js";
import Chat from "./Lobby/Channel"
import "bootstrap/dist/css/bootstrap.min.css";
import Nav from "./Nav";
import { fetch_tracks } from "./api";
import { useState, useEffect } from "react";


// Get the hash of the url
const hash = window.location.hash
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

function App() {
  let _token = hash.access_token;
  const [state, setState] = useState({
    loggedIn: false,
    token: false,
    tracks: false,
  });
  useEffect(() => {
    if (_token) {
      setState({ loggedIn: false, token: _token, tracks: false });
    }
  }, [_token]);

  // function getTopTracks() {
  //   data = fetch_tracks(state.token)
  // }

  // let body = <Register spotify={state.token} submit={getTopTracks}></Register>;
  // if (state.tracks) {
  //   body = <p>{JSON.stringify(state.tracks.items)}</p>;
  //   body = <Tracks tracks={state.tracks.items} />;
  // }

  let body = (
    <Switch>
      <Route path="/" exact>
        <Chat />
      </Route>
      <Route path="/register" exact>
        <Register spotify={state.token} submit={console.log}></Register>
      </Route>
      <Route path="/tracks" exact>
        <TrackList />
      </Route>
      <Route path="/login" exact>
        <Login />
      </Route>
      <Route path="/matches" exact>
        <p>Match List</p>
      </Route>
    </Switch>
  );
  // if (session) {
  //   body = (
  //     <Switch>
  //       <Route path="/" exact>
  //         <Register spotify={state.token} submit={getTopTracks}></Register>
  //       </Route>
  //       <Route path="/tracks" exact>
  //         <Tracks track={state.tracks.items} />
  //       </Route>
  //     </Switch>
  //   );
  // }
  return (
    <Container fluid>
      <Nav />
      {body}
    </Container>
  );
}

export default App;

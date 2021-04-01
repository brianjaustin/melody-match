import "./App.scss";
import { Tracks } from "./Tracks/Tracks";
import { useState, useEffect } from "react";
import { Register } from "./Login/Register";
import "bootstrap/dist/css/bootstrap.min.css";

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

  function getTopTracks() {
  }

  let body = <Register spotify={state.token} submit={getTopTracks}></Register>;
  if (state.tracks) {
    body = <p>{JSON.stringify(state.tracks.items)}</p>;
    body = <Tracks tracks={state.tracks.items} />;
  }
  return (
    <div className="App">
      <header className="App-header">Melody Matches</header>
      {body}
    </div>
  );
}

export default App;

import { Container, Table, Button } from "react-bootstrap/cjs";
import { connect } from "react-redux";
import { fetch_previous_matches } from "../api";
import { useEffect, useCallback } from "react";
export const authEndpoint = "https://accounts.spotify.com/authorize";
const clientId = "135bad1f37bc489b95aa2c2d2e7fd4c6";
const redirectUri = "http%3A%2F%2Flocalhost%3A3000%2Fuser";
const scopes = ["user-top-read"];

function EditUser({ session }) {


  let spotify_component = (
    <Button
      href={`${authEndpoint}?response_type=token&client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scopes.join(
        "%20"
      )}&show_dialog=true`}
      className="spotify"
    >
      Refresh Spotify Token
    </Button>
  );

  return (
    <Container>
      {spotify_component}
      <p>{JSON.stringify(session)}</p>
    </Container>
  );
}

function state2props({ session }) {
  return { session };
}

export default connect(state2props)(EditUser);

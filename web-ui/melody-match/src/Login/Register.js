import "./Register.scss";
import { Form, Button, Container} from "react-bootstrap";
import React, {useEffect, useState} from 'react';

export const authEndpoint = "https://accounts.spotify.com/authorize";
// Replace with your app's client ID, redirect URI and desired scopes
const clientId = process.env.REACT_APP_CLIENT_ID;
const redirectUri = "http%3A%2F%2Flocalhost%3A3000";
const scopes = ["user-top-read"];


export function Register({spotify, submit}) {


  let spotify_component = (
    <Button
      href={`${authEndpoint}?response_type=token&client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scopes.join(
        "%20"
      )}&show_dialog=true`}
      className="spotify"
    >
      Login to Spotify
    </Button>
  );

  if (spotify){
    console.log(spotify)
    spotify_component = (
      <div>
        {" "}
        <Button
          href={`${authEndpoint}?response_type=token&client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scopes.join(
            "%20"
          )}&show_dialog=true`}
          className="spotify"
          disabled
        >
          Login to Spotify
        </Button>
        <p>Token has been collected</p>
      </div>
    );
  }

  return (
    <div className="Register">
      <Container>
        <h2>Register a New User</h2>
        <Container>
          <p>Step 1: Allow Spotify Access.</p>
          {spotify_component}
        </Container>
        <hr />
        <Container>
          <p>Step 2: Fill in Personal Information</p>
          <Form>
            <Form.Group controlId="formBasicEmail">
              <Form.Label>User Name</Form.Label>
              <Form.Control type="text" placeholder="Enter user name" />
            </Form.Group>

            <Form.Group controlId="formBasicEmail">
              <Form.Label>Email address</Form.Label>
              <Form.Control type="email" placeholder="Enter email" />
              <Form.Text className="text-muted">
                Email will be used to connect you with other users.
              </Form.Text>
            </Form.Group>

            <Button variant="primary" onClick={submit}>
              Submit
            </Button>
          </Form>
        </Container>
      </Container>
    </div>
  );
}

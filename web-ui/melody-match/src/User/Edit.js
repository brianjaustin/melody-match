import { connect } from "react-redux";
import { api_login, fetch_users } from "../api";
import { Form, Button, Container, Row, Col, Alert } from "react-bootstrap";
import React, { useEffect, useState, useCallback } from "react";
import { api_patch } from "../api";

export const authEndpoint = "https://accounts.spotify.com/authorize";
const clientId = "135bad1f37bc489b95aa2c2d2e7fd4c6";
const redirectUri = "http%3A%2F%2Flocalhost%3A3000";
const scopes = ["user-top-read"];

function EditUser({ session, users }) {
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [userName, setUserName] = useState(users.name);
  const [email, setEmail] = useState(users.email);
  const [alert, setAlert] = useState(
    <Alert key="registration_response" variant="primary">
      Fill out form to register a new user
    </Alert>
  );
  const [position, setPosition] = useState({
    coords: { latitude: 0, longitude: 0 },
  });
  const getUsersCallback = useCallback(() => {
    fetch_users(session.user_id, session.token);
  });

  useEffect(() => {
    getUsersCallback();
  }, []);

  useEffect(() => {
    navigator.geolocation.getCurrentPosition(setPosition);
  }, []);

  const handleSubmit = (event) => {
    event.preventDefault();
    const form = event.currentTarget;
    if (form.checkValidity() === false) {
      event.stopPropagation();
    }

    if (password == confirmPassword) {
      api_patch(
        `/users/${session.user_id}`,
        {
          email: email,
          name: userName,
          password: password,
        },
        session.token
      ).then((data) => {
        if (data.data) {
          setAlert(
            <Alert key="registration_response" variant="primary">
              User Sucessfully Updated.
            </Alert>
          );

          api_login(
            email,
            password,
            position.coords.latitude,
            position.coords.longitude
          );
        } else if (data.errors) {
          setAlert(
            <Alert key="registration_response" variant="danger">
              User could not be created {JSON.stringify(data.errors)}
            </Alert>
          );
        }
      });
    }
  };

  let spotify_component = (
    <Button
      href={`${authEndpoint}?response_type=code&client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scopes.join(
        "%20"
      )}&show_dialog=true`}
      className="spotify"
    >
      Refresh Spotify Token
    </Button>
  );

  return (
    <Container>
      {alert}
      {spotify_component}
      <Form onSubmit={handleSubmit}>
        <Form.Row>
          <Form.Group as={Col} md="4" controlId="validationCustom01">
            <Form.Label>User Name Currently: {users.name}</Form.Label>
            <Form.Control
              required
              type="text"
              placeholder={userName}
              onChange={(e) => setUserName(e.target.value)}
            />
            <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
          </Form.Group>
        </Form.Row>
        <Form.Row>
          <Form.Group as={Col} md="8" controlId="validationCustom02">
            <Form.Label>Email Currently: {users.email}</Form.Label>
            <Form.Control
              required
              type="email"
              placeholder={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
          </Form.Group>
        </Form.Row>
        <Form.Row>
          <Form.Group as={Col} md="6" controlId="validationCustom02">
            <Form.Label>Password</Form.Label>
            <Form.Control
              required
              type="password"
              onChange={(e) => setPassword(e.target.value)}
              isInvalid={password.length < 10}
            />
            <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
            <Form.Control.Feedback type="invalid">
              Password must be 10 characters or longer
            </Form.Control.Feedback>
          </Form.Group>
          <Form.Group as={Col} md="6" controlId="validationCustom02">
            <Form.Label>Confirm Password</Form.Label>
            <Form.Control
              required
              type="password"
              onChange={(e) => setConfirmPassword(e.target.value)}
              isInvalid={password != confirmPassword}
              isValid={password == confirmPassword}
            />
            <Form.Control.Feedback type="valid">
              Passwords match.
            </Form.Control.Feedback>
            <Form.Control.Feedback type="invalid">
              Passwords do not match
            </Form.Control.Feedback>
          </Form.Group>
        </Form.Row>
        <p>
          Please accept Location permissions when submitting in order to
          proceed.
        </p>
        <Button type="submit">Submit form</Button>
      </Form>
    </Container>
  );
}

function state2props({ session, users }) {
  return { session, users };
}

export default connect(state2props)(EditUser);

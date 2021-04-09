import "./Register.scss";
import { Form, Button, Container, Row, Col, InputGroup, Alert} from "react-bootstrap";
import React, {useEffect, useState} from 'react';
import { api_post } from "../api";
import { connect } from "react-redux";

export const authEndpoint = "https://accounts.spotify.com/authorize";
// Replace with your app's client ID, redirect URI and desired scopes
// const clientId = process.env.REACT_APP_CLIENT_ID;
const clientId = "135bad1f37bc489b95aa2c2d2e7fd4c6";
const redirectUri = "http%3A%2F%2Flocalhost%3A3000";
const scopes = ["user-top-read"];


function Register({spotifyToken}) {
  const [validated, setValidated] = useState(false);
  const [password, setPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [userName, setUserName] = useState("")
  const [email, setEmail] = useState("")
  const [alert, setAlert] = useState(
    <Alert key="registration_response" variant="primary">
      Fill out form to register a new user
    </Alert>
  );

  let errorMessage=""

  const handleSubmit = (event) => {
    console.log("testing submit")
    event.preventDefault();
    navigator.geolocation.getCurrentPosition(function (position) {
      console.log(position);
    });
    const form = event.currentTarget;
    if (form.checkValidity() === false) {

      event.stopPropagation();
    }

    console.log(form)

    if(password != confirmPassword){
      console.log("Passwords do not match")
      errorMessage = "Passwords Do Not Match"
      setValidated(false)

    }else{
      setValidated(true);
      api_post("/users", {
        email: email,
        name: userName,
        password: password,
      }).then((data) => {
        console.log("register resp", data);
        if (data.data) {
          setAlert(
            <Alert key="registration_response" variant='primary'>
              User sucessfully created.
            </Alert>
          );
        } else if (data.errors) {
          console.log("FOUND ERRORS")
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
      Login to Spotify
    </Button>
  );

  let registration_form = (<p>Complete Step 1</p>)


  if (spotifyToken){
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
    registration_form = (
      <Form onSubmit={handleSubmit}>
        <Form.Row>
          <Form.Group as={Col} md="4" controlId="validationCustom01">
            <Form.Label>User Name</Form.Label>
            <Form.Control
              required
              type="text"
              placeholder="User Name"
              onChange={(e) => setUserName(e.target.value)}
            />
            <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
          </Form.Group>
        </Form.Row>
        <Form.Row>
          <Form.Group as={Col} md="8" controlId="validationCustom02">
            <Form.Label>Email</Form.Label>
            <Form.Control
              required
              type="email"
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
            <p>{errorMessage}</p>
          </Form.Group>
        </Form.Row>
        <p>
          Please accept Location permissions when submitting in order to
          proceed.
        </p>
        <Button type="submit">Submit form</Button>
      </Form>
    );
  }

  return (
    <div className="Register">
      {alert}
      <Container>
        <Row>
          <h2 className="page-title">Register a New User</h2>
        </Row>
        <Row>
          <Container>
            <p>Step 1: Allow Spotify Access.</p>
            {spotify_component}
          </Container>
        </Row>
        <hr />
        <Row>
          <Container>
            <p>Step 2: Fill in Personal Information</p>
            {registration_form}
          </Container>
        </Row>
      </Container>
    </div>
  );
}

function state2props({ spotifyToken }) {
  return { spotifyToken };
}

export default connect(state2props)(Register);

import "./Login.scss";
import { Form, Button, Container, Row, Col, InputGroup } from "react-bootstrap";
import React, { useEffect, useState } from "react";
import { api_login } from "../api";
import { Redirect } from "react-router";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [position, setPosition] = useState({
    coords: { latitude: 0, longitude: 0 },
  });
  const [redirect, setRedirect] = useState("")

  useEffect(() => {
    navigator.geolocation.getCurrentPosition(setPosition);
  }, []);

  const handleSubmit = (event) => {
    event.preventDefault();
    const form = event.currentTarget;
    api_login(email, password, position.coords.latitude, position.coords.longitude);
    setRedirect(<Redirect to="/" />);
  };

  return (
    <div className="Login">
      <Container>
        {redirect}
        <Row>
          <h2>Login</h2>
        </Row>
        <Form onSubmit={handleSubmit}>
          <Form.Row>
            <Form.Group as={Col} md="10" controlId="validationCustom02">
              <Form.Label>Email</Form.Label>
              <Form.Control
                required
                type="email"
                onChange={(ev) => setEmail(ev.target.value)}
              />
              <Form.Control.Feedback type="valid">
                Looks good!
              </Form.Control.Feedback>
              <Form.Control.Feedback type="invalid">
                Please Enter Email
              </Form.Control.Feedback>
            </Form.Group>
          </Form.Row>
          <Form.Row>
            <Form.Group as={Col} md="10" controlId="validationCustom02">
              <Form.Label>Password</Form.Label>
              <Form.Control
                required
                type="password"
                onChange={(ev) => setPassword(ev.target.value)}
              />
              <Form.Control.Feedback type="valid">
                Looks good!
              </Form.Control.Feedback>
              <Form.Control.Feedback type="invalid">
                Please Enter Password
              </Form.Control.Feedback>
            </Form.Group>
          </Form.Row>
          <Button type="submit">Submit form</Button>
        </Form>
      </Container>
    </div>
  );
}

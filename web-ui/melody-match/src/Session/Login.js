import "./Login.scss";
import { Form, Button, Container, Row, Col, InputGroup } from "react-bootstrap";
import React, { useEffect, useState } from "react";
import { api_login } from '../api';

export default function Login() {
  const [validated, setValidated] = useState(false);
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const handleSubmit = (event) => {
    event.preventDefault();
    console.log("testing submit");
    console.log(email);
    console.log(password);
    navigator.geolocation.getCurrentPosition(function (position) {
      console.log(position);
    });
    const form = event.currentTarget;
    console.log(event);
    api_login(email, password);

  }
  
  return (
    <div className="Login">
      <Container>
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

import "./Login.scss";
import { Form, Button, Container, Row, Col, InputGroup } from "react-bootstrap";
import React, { useEffect, useState } from "react";

export function Login() {
  const [validated, setValidated] = useState(false);
  const handleSubmit = (event) => {
    console.log("testing submit")
    navigator.geolocation.getCurrentPosition(function (position) {
      console.log(position);
    });
    const form = event.currentTarget;
    if (form.checkValidity() === false) {
      event.preventDefault();
      event.stopPropagation();
    }
      setValidated(true);

  }
  
  return (
    <div className="Login">
      <Container>
        <Row>
          <h2>Login</h2>
        </Row>
        <Form noValidate validated={validated} onSubmit={handleSubmit}>
          <Form.Row>
            <Form.Group as={Col} md="10" controlId="validationCustom02">
              <Form.Label>Email</Form.Label>
              <Form.Control required type="email" />
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
              <Form.Control required type="password" />
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

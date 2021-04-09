import "./Nav.scss";

import { Nav, Row, Col, Form, Button, Alert, Container } from "react-bootstrap";
import { NavLink } from "react-router-dom";
import { connect } from "react-redux";
import { useState } from "react";

import { api_login } from "./api";
import store from "./store";

function LoginForm() {
  const [name, setName] = useState("");
  const [pass, setPass] = useState("");

  function on_submit(ev) {
    ev.preventDefault();
    // api_login(name, pass);
  }

  return (
    <Container className="login-or-register">
      <Row>
        <Col>
          <Link to="/register">
            <Button variant="primary">Register</Button>
          </Link>
        </Col>
        <Col>
          <Link to="/login">
            <Button variant="primary">Login</Button>
          </Link>
        </Col>
      </Row>
    </Container>
  );
}

function SessionInfo({ session }) {
  function logout(ev) {
    ev.preventDefault();
    store.dispatch({ type: "session/clear" });
  }

  return (
    <p className="contrast">
      Logged in as {session.name}
      <Button onClick={logout}>Logout</Button>
    </p>
  );
}

function LOI({ session }) {
  if (session) {
    return <SessionInfo session={session} />;
  } else {
    return <LoginForm />;
  }
}

const LoginOrInfo = connect(({ session }) => ({ session }))(LOI);

function Link({ to, children }) {
  return (
    <Nav.Item>
      <NavLink to={to} exact className="nav-link" activeClassName="active">
        {children}
      </NavLink>
    </Nav.Item>
  );
}

function AppNav({ error }) {
  let error_row = null;

  if (error) {
    error_row = (
      <Row>
        <Col>
          <Alert variant="danger">{error}</Alert>
        </Col>
      </Row>
    );
  }

  return (
    <div>
      <Row className="nav">
        <Col>
          <Nav variant="tabs">
            <Link to="/">Lobby</Link>
            <Link to="/matches">My Previous Matches</Link>
            <Link to="/tracks">My Top Tracks</Link>
          </Nav>
        </Col>
        <Col>
          <LoginOrInfo />
        </Col>
      </Row>
      {error_row}
    </div>
  );
}

export default connect(({ error }) => ({ error }))(AppNav);

import "./Lobby.scss";
import { Row, Col, Container, Spinner } from "react-bootstrap";
import React, { useEffect, useState } from "react";

export function Lobby() {

  return (
    <div className="Login">
      <Container>
        <Row>
          <Col>
            <h2>Waiting for a match</h2>
          </Col>
          <Col>
            <Spinner animation="border" role="status" className="spinner">
              <span className="sr-only">Loading...</span>
            </Spinner>
          </Col>
        </Row>
      </Container>
    </div>
  );
}

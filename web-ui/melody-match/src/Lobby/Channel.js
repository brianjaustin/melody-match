/**
 * This code is based on my work for the React
 * browser game assignment (HW 03). It (including
 * the code in `socket.js`) also uses work from lectures,
 * see the scratch repository
 * (https://github.com/NatTuck/scratch-2021-01/tree/master/4550/0212/hangman)
 * for details.
 */

import React, { useState, useEffect } from "react";
import { Container, Row, Col, Spinner, Button, ListGroup } from "react-bootstrap";
import { ch_join_lobby, ch_push, ch_start, ch_leave } from "../socket";
import _ from "lodash";
import { connect } from "react-redux";
import { api_login } from "../api";
import "./Lobby.scss";
import store from "../store";

function ErrorMessage({ msg }) {
  if (msg) {
    return (
      <p class="alert alert-danger" role="alert">
        {msg}
      </p>
    );
  } else {
    return null;
  }
}

function Lobby() {


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

function NotLoggedIn(){
  return (
    <div className="pre-lobby">
      <Container>
        <h4>Please login or register in order to join chat.</h4>
      </Container>
    </div>
  );
}

function PreLobby({submit}) {
  return (
    <div className="pre-lobby">
      <Container>
        <h4>Press the button to join the lobby and start finding matches.</h4>
        <Button variant="primary" onClick={submit}>Find Matches</Button>
      </Container>
    </div>
  );
}

function ChatHistory({messages, session}) {
  function renderMsg(chat){
    if (chat.message){
      if(chat.sender == session.name){
        return (
          <ListGroup.Item>
            <div className="sent">
              <strong>You</strong>
              <p>{chat.message}</p>
            </div>
          </ListGroup.Item>
        );
      } else {
        return (
          <ListGroup.Item>
            <div className="recieved">
              <strong>{chat.sender}</strong>
              <p>{chat.message}</p>
            </div>
          </ListGroup.Item>
        );
      }

    }

  }

  const listItems = messages.map((msg) => renderMsg(msg));
  return (
    <Container>
      <ListGroup>
        {listItems}
      </ListGroup>
    </Container>
  );
}

function state2props({ messages, session }) {
  return { messages, session };
}

const MessageChat =  connect(state2props)(ChatHistory);

function ActiveChat({ token, userId }) {
  const [msgText, setMsgText] = useState("");

  function send() {
    ch_push("sendChatMessage", { message: msgText, token: token });
    setMsgText("")
  }

  // Update functions based on code from lecture from 2021-01-29:
  // https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0129/hangman/src/App.js
  function updateGuess(ev) {
    let msg = ev.target.value;
    setMsgText(msg);
  }

  function keyPress(ev) {
    if (ev.key === "Enter") {
      send();
    }
  }

  function reset(){
        ch_push("chatUserLeft", { message: "", token: token });
        ch_leave();
        ch_join_lobby(userId, token);
  }

  let input_guess = (
    <Row>
      <Col>
        <input
          type="text"
          value={msgText}
          onChange={updateGuess}
          onKeyPress={keyPress}
          className="text-input"
        />
      </Col>
      <Col className="send-button">
        <Button onClick={send}>Send</Button>
      </Col>
      <Col className="leave-channel-button">
        <Button
          onClick={() => {
            reset();
            setMsgText("");
          }}
        >
          Leave Channel
        </Button>
      </Col>
    </Row>
  );

  return (
    <Container>
      <h2>Chat Channel</h2>
      {input_guess}
      <MessageChat />
    </Container>
  );
}



function Chat({ messages, session }) {
  const [chatState, setChatState] = useState(0);

  function enterLobby(){
    if (session){
      setChatState(1);
      ch_join_lobby(session.user_id, session.token);
    }

  }

  function matchFound(){
    if (chatState == "chatUserLeft"){
      setChatState(0);
    }
    ch_start(messages[0].matchId, session.token)
    setChatState(2)
  }

  function reset(){
    setChatState(0)
  }

  if (session == null){
    return <NotLoggedIn />;
  } else if (chatState == 0) {
    return <PreLobby submit={enterLobby}/>;
  } else if (messages.length > 0 && messages[0].matchId && chatState == 1) {
    matchFound()
    return (
      <ActiveChat token={session.token} userId={session.user_id} />
    );
  } else if (chatState == 2 && messages == "CHANNEL_LEFT"){
    reset();
    return <PreLobby submit={enterLobby} />;
  } else if (chatState == 2){
    return <ActiveChat token={session.token} userId={session.user_id} />;
  } else if (chatState.message){
    return <ActiveChat token={session.token} userId={session.user_id} />;
  } else {
    return <Lobby />;
  }
}

function state2props2({ messages, session }) {
  return { messages, session };
}

export default connect(state2props2)(Chat);

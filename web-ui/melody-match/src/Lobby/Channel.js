/**
 * This code is based on my work for the React
 * browser game assignment (HW 03). It (including
 * the code in `socket.js`) also uses work from lectures,
 * see the scratch repository
 * (https://github.com/NatTuck/scratch-2021-01/tree/master/4550/0212/hangman)
 * for details.
 */

import React, { useState, useEffect } from "react";
import { Container, Row, Col, Spinner, Button } from "react-bootstrap";
import { ch_join, ch_join_lobby, ch_push, ch_start, ch_leave } from "../socket";
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

function ChatHistory({messages}) {
  return(
    <h4>{JSON.stringify(messages)}</h4>
  )
}

const MessageChat = connect(({ messages }) => ({ messages }))(ChatHistory);

function ActiveChat({ token, userId }) {
  const [msgText, setMsgText] = useState("");

  function send() {
    console.log(reset)
    ch_push("sendChatMessage", { message: msgText, token: token });
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
        console.log("LEAVING CHANNEL");
        console.log(token, userId)
        ch_push("chatUserLeft", { message: "", token: token });
        ch_leave();
        ch_join_lobby(userId, token);
  }

  let input_guess = (
    <div className="row">
      <div className="column column-60">
        <input
          type="text"
          value={msgText}
          onChange={updateGuess}
          onKeyPress={keyPress}
        />
      </div>
      <div className="column">
        <button onClick={send}>Send</button>
      </div>
      <div className="column">
        <button
          onClick={() => {
            reset();
            setMsgText("");
          }}
        >
          Leave Channel
        </button>
      </div>
    </div>
  );

  return (
    <div>
      <h1>Bulls</h1>
      <p>Guess a 4 digit number:</p>
      {input_guess}
      <MessageChat />
    </div>
  );
}



function Chat({ messages, session }) {
  const [chatState, setChatState] = useState(0);

  function enterLobby(){
    setChatState(1);
    ch_join_lobby(session.user_id, session.token)
  }

  function matchFound(){
    console.log(chatState)
    if (chatState == "chatUserLeft"){
      setChatState(0);
    }
    ch_start(messages[0].matchId, session.token)
    setChatState(2)
  }

  function reset(){
    setChatState(0)
  }

  if (chatState == 0) {
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

function state2props({ messages, session }) {
  return { messages, session };
}

export default connect(state2props)(Chat);

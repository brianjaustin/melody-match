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
import { ch_join, ch_join_lobby, ch_push, ch_start } from "../socket";
import _ from "lodash";
import { connect } from "react-redux";
import { api_login } from "../api";

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

function ActiveChat({ token, messages }) {
  const [msgText, setMsgText] = useState("");

  function send() {
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
    </div>
  );

  return (
    <div>
      <h1>Bulls</h1>
      <p>Guess a 4 digit number:</p>
      {input_guess}
      <p>{JSON.stringify(messages)}</p>
    </div>
  );
}

function Chat({ messages, match_found, session }) {
  const [chatState, setChatState] = useState(0);
  const [inChat, setInChat] = useState(false);

  function setChatStateFunc(st) {
    console.log("setting chat state based on message")
    let new_state = Object.assign(st, { player_name: session.name });
    setChatState(new_state);
  }

    useEffect(() => {
      ch_join(setChatState);
    }, [chatState]);

  function enterLobby(){
    setChatState(1);
    ch_join_lobby(session.user_id, session.token)
  }

  function matchFound(){
    console.log(chatState)
    if (chatState == "chatUserLeft"){
      setChatState(0);
    }
    ch_start(chatState.matchId, session.token)
  }

  if (chatState == 0) {
    return <PreLobby submit={enterLobby}/>;

  } else if (chatState.matchId) {
    matchFound()
    return (
      <ActiveChat token={session.token} messages={chatState} />
    );
  } else if (chatState == "Joined Chat"){
    return <ActiveChat token={session.token} messages={chatState} />;
  } else {
    return <Lobby />;
  }
}

function state2props({ messages, match_found, session }) {
  return { messages, match_found, session };
}

export default connect(state2props)(Chat);

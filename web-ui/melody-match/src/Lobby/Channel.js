/**
 * This code is based on my work for the React
 * browser game assignment (HW 03). It (including
 * the code in `socket.js`) also uses work from lectures,
 * see the scratch repository
 * (https://github.com/NatTuck/scratch-2021-01/tree/master/4550/0212/hangman)
 * for details.
 */

import React, { useState, useEffect } from "react";
import {Container, Row, Col, Spinner} from "react-bootstrap";
import { ch_join, ch_push, ch_start } from "../socket";
import _ from "lodash";
import { connect } from "react-redux";


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

function ActiveChat({ reset, gameState, setGameState }) {
  const [currentGuess, setCurrentGuess] = useState("");

  function guess() {
    ch_push("guess", { number: currentGuess });
  }

  function pass() {
    ch_push("guess", { number: "----" });
  }

  // Update functions based on code from lecture from 2021-01-29:
  // https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0129/hangman/src/App.js
  function updateGuess(ev) {
    let guess = ev.target.value;
    setCurrentGuess(guess);
  }

  function keyPress(ev) {
    if (ev.key === "Enter") {
      guess();
    }
  }

  function displayGuesses(player_info) {
    let player_name = player_info[0];
    let guesses = player_info[1];
    return guesses.map((guess, index) =>
      displayGuess(guess, player_name, index)
    );
  }

  function displayGuess(guess, name, index) {
    return (
      <tr key={String(guess.guess).concat(String(name).concat(index))}>
        <td>{name}</td>
        <td>{guess.guess}</td>
        <td>{`${guess.a}A${guess.b}B`}</td>
      </tr>
    );
  }

  let guesses = (
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Guess</th>
          <th>Result</th>
        </tr>
      </thead>
      <tbody>
        {Object.entries(gameState.guesses).map((guesses) =>
          displayGuesses(guesses)
        )}
      </tbody>
    </table>
  );

  let input_guess = (
    <div className="row">
      <div className="column column-60">
        <input
          type="text"
          value={currentGuess}
          onChange={updateGuess}
          onKeyPress={keyPress}
        />
      </div>
      <div className="column">
        <button onClick={guess}>Guess</button>
      </div>
      <div className="column">
        <button onClick={pass}>Pass</button>
      </div>
    </div>
  );

  if (gameState.participants[gameState.player_name][0] != "player") {
    input_guess = <p>Only Ready Players can guess</p>;
  }

  return (
    <div>
      <h1>Bulls</h1>
      <p>Guess a 4 digit number:</p>
      <ErrorMessage msg={gameState.error} />
      {input_guess}
      <div className="column">
        <button
          className="button button-outline"
          onClick={() => {
            reset();
            setCurrentGuess("");
          }}
        >
          Reset Game
        </button>
      </div>
      {guesses}
    </div>
  );
}

function Chat({channel}) {
  const [gameState, setGameState] = useState({
    guesses: [],
    participants: [],
    previous_winners: [],
    lobby: true,
    error: "",
    player_name: "",
  });

  function setGameStateWOName(st) {
    let new_state = Object.assign(st, { player_name: gameState.player_name });
    setGameState(new_state);
  }

  function setName(name) {
    let new_state = gameState;
    new_state.player_name = name;
    setGameState(new_state);
  }

  useEffect(() => ch_join(setGameStateWOName));

  function addChatMember(match_id, token) {
    ch_start(match_id, { token: token });
  }


  function reset() {
    ch_push("reset", "");
  }

  if (gameState.lobby) {
    return (
      <Lobby />
    );
  } else {
    return (
      <ActiveChat
        reset={reset}
        gameState={gameState}
        setGameState={setGameState}
      />
    );
  }
}

function state2props({ channel }) {
  return { channel };
}

export default connect(state2props)(Chat);

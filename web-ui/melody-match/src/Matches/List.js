import { Container, Table } from "react-bootstrap/cjs";
import { connect } from "react-redux";
import { fetch_previous_matches } from "../api";
import { useEffect, useCallback } from "react";

function MatchList({ matches }) {
  const getMatchesCallback = useCallback(() => {
    fetch_previous_matches();
  });

  useEffect(() => {
    getMatchesCallback();
  }, []);

  function rendermatch(match){
      return (
          <tr>
              <td>{match.id}</td>
              <td>{match.users[0].name}:{match.users[0].email}</td>
              <td>{match.users[1].name}:{match.users[1].email}</td>
          </tr>
      )
  }

    const listItems = matches.matches.map((match) => rendermatch(match));

  

  return (
    <div className="Tracks">
      <Container>
        <h2>Your Previous Matches</h2>
        <Table striped bordered hover>
          <thead>
            <tr>
              <th>#</th>
              <th>Name</th>
              <th>Email</th>
            </tr>
          </thead>
          <tbody>
            {listItems}
          </tbody>
        </Table>
      </Container>
    </div>
  );
}

function state2props({ matches }) {
  return { matches };
}

export default connect(state2props)(MatchList);

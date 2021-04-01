import { Container, ListGroup, Row, Col } from "react-bootstrap/cjs";
import "./Tracks.scss";

export function Tracks({ tracks }) {
  const listItems = tracks.map((track) => (
    rendertrack(track)
  ));

  function intersperse(arr, sep) {
    if (arr.length === 0) {
      return [];
    }

    return arr.slice(1).reduce(
      function (xs, x, i) {
        return xs.concat([sep, x]);
      },
      [arr[0]]
    );
  }

  function rendertrack(track) {
    const artists = track.artists.map((artist) => <strong key={artist.name}>{artist.name}</strong>);
    return (
      <ListGroup.Item key={track.href}>
        <Row>
          <Col>
            <img
              src={track.album.images[1].url}
              alt={track.album.name}
              className="rounded float-left album-art"
            />
          </Col>
          <Col>
            <p>
              Artist(s):
              {intersperse(artists, ", ")}
            </p>
            <p>
              Name: <strong>{track.name}</strong>
            </p>
            <p>
              Album: <strong>{track.album.name}</strong>
            </p>
          </Col>
        </Row>
      </ListGroup.Item>
    );
  }

  return (
    <div className="Tracks">
      <Container>
        <h2>Your Top Tracks</h2>
        <ListGroup>{listItems}</ListGroup>
      </Container>
    </div>
  );
}

import store from "./store";
import * as $ from "jquery";

export async function api_get(path) {
  let text = await fetch("http://localhost:4000/api/v1" + path, {});
  let resp = await text.json();
  return resp.data;
}

export function fetch_users() {
  api_get("/users").then((data) =>
    store.dispatch({
      type: "users/set",
      data: data,
    })
  );
}

export function fetch_tracks() {
  $.ajax({
    url: "https://api.spotify.com/v1/me/top/tracks?limit=10",
    type: "GET",
    beforeSend: (xhr) => {
      xhr.setRequestHeader(
        "Authorization",
        "Bearer BQDtR3GcfmD6DvozFdgA9yiHSWpnTM-X6wE7rdJ8Q6POrBVfovVKFwVYbGH9pJf1hR0SR8TjNhA2WhdBdNA6BBw3AB9xPuFL9cLj3REQOWcmMBCBZD6NXslv-gb2Y3pzMzz_t0RHMRCYTZUVOODaCkpH"
      );
    },
    success: (data) => {
      console.log("fetched tracks")
      console.log(data)
      store.dispatch({
        type: "tracks/set",
        data: data.items,
      });
    },
  });
}

export function fetch_previous_matches(){
  let matches = {
    matches: [
      {
        id: 4,
        users: [
          {
            id: 4,
            email: "rose@email.com",
            name: "Rose",
          },
          {
            id: 5,
            email: "betsy@email.com",
            name: "Betsy",
          },
        ],
      },
      {
        id: 5,
        users: [
          {
            id: 4,
            email: "rose@email.com",
            name: "Rose",
          },
          {
            id: 6,
            email: "bob@email.com",
            name: "Bob",
          },
        ],
      },
    ],
  };

  console.log(matches)
  store.dispatch({type: "matches/set", data:matches})

}

export function load_defaults() {
  fetch_users();
  fetch_tracks();
  fetch_previous_matches();
}

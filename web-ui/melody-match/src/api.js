import store from "./store";
import * as $ from "jquery";

export async function api_get(path) {
  let text = await fetch("http://localhost:4000/api/v1" + path, {});
  let resp = await text.json();
  return resp.data;
}

async function api_post(path, data) {
  let opts = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  };
  let resp = await fetch("http://localhost:4000/api/v1" + path, opts);
  return await resp.json();
}

export function api_login(email, password) {
  api_post("/session", { email, password }).then((data) => {
    console.log("login resp", data);
    if (data.session) {
      let action = {
        type: "session/set",
        data: data.session,
      };
      store.dispatch(action);
    } else if (data.error) {
      console.log(data.error);
      let action = {
        type: "error/set",
        data: data.error,
      };
      store.dispatch(action);
    }
  });
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

export function fetch_previous_matches(user_id=-1){

  if (user_id > -1){
    console.log(`FETCHING ACTUAL MATCHES FOR USER ${user_id}`)
    api_get(`/users/${user_id}/matches`).then((data) =>
      store.dispatch({
        type: "matches/set",
        data: data,
      })
    );
  } else {
    console.log("NO MATCHES YET")
    store.dispatch({type: "matches/set", data: {data: []}})
  }

}

export function load_defaults() {
  fetch_users();
  fetch_tracks();
  fetch_previous_matches();
}

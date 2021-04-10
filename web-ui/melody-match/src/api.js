import store from "./store";
import * as $ from "jquery";

export async function api_get(path, token=null) {
  let opts = {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      "x-auth": token
    }
  };
  let text = await fetch("http://localhost:4000/api/v1" + path, opts);
  let resp = await text.json();
  return resp.data;
}

export async function api_post(path, data, token=null) {
  let opts = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-auth": token
    },
    body: JSON.stringify(data),
  };
  let resp = await fetch("http://localhost:4000/api/v1" + path, opts);
  return await resp.json();
}

export async function api_patch(path, data, token=null) {
  let opts = {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "x-auth": token
    },
    body: JSON.stringify(data),
  };
  let resp = await fetch("http://localhost:4000/api/v1" + path, opts);
  return await resp.json();
}

export function api_login(email, password, latitude, longitude) {
  api_post("/session", { email, password, latitude, longitude }).then((data) => {
    if (data.session) {
      let action = {
        type: "session/set",
        data: data.session,
      };
      store.dispatch(action);
    } else if (data.error) {
      let action = {
        type: "error/set",
        data: data.error,
      };
      store.dispatch(action);
    }
  });
}

export function fetch_users(user_id=-1, token=null) {
  if (user_id > -1) {
    api_get(`/users/${user_id}`, token).then((data) =>
      store.dispatch({
        type: "users/set",
        data: data,
      })
    );
  } else {
    store.dispatch({ type: "users/set", data: {} });
  }
}

export function fetch_tracks(user_id=-1, token=null) {
  if (user_id > -1) {
    api_get(`/users/${user_id}/top_songs`, token).then((data) => {
      store.dispatch({
        type: "tracks/set",
        data: data.items,
      })
    });
  } else {
    store.dispatch({ type: "tracks/set", data: [] });
  }
}

export function fetch_previous_matches(user_id=-1, token=null){

  if (user_id > -1){
    api_get(`/users/${user_id}/matches`, token).then((data) =>
      store.dispatch({
        type: "matches/set",
        data: data,
      })
    );
  } else {
    store.dispatch({type: "matches/set", data: []})
  }

}

export function load_defaults() {
  fetch_users();
  fetch_tracks();
  fetch_previous_matches();
}

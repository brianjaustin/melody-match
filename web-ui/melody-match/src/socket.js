import { Socket } from "phoenix";
import store from "./store";

let socket = null;

let channel = null;

function store_update(st){
  let action = {
    type: "messages/append",
    data: st,
  };
  store.dispatch(action);
}

export function ch_leave(){
  socket = null;
  let action = {
    type: "messages/set",
    data: "CHANNEL_LEFT",
  };
  store.dispatch(action);
}

export function message_clear(){
  let action = {
    type: "messages/clear",
    data: "CHANNEL_LEFT",
  };
  store.dispatch(action);
}

export function ch_join_lobby(user_id, token) {
  message_clear();
  socket = new Socket("ws://localhost:4000/socket", {
    params: { token: "" },
  });
  socket.connect();
  channel = socket.channel(`matchmaker:${user_id}`, {token: token});
  channel
    .join()
    .receive("ok", console.log)
    .receive("error", (resp) => console.log("Unable to join matchmaker channel", resp));
  channel.on("matchFound", store_update);
}

export function ch_start(match_id, token) {
  if (channel == null){
      socket = new Socket("ws://localhost:4000/socket", {
        params: { token: "" },
      });
      socket.connect();
  }
  channel = socket.channel(`chat:${match_id}`, {token: token});
  channel
    .join()
    .receive("ok", console.log)
    .receive("error", (resp) => console.log("Unable to join chat channel", resp));
  channel.on("receiveChatMessage", store_update);
  channel.on("chatUserLeft", ch_leave);
}

export function ch_push(type, msg) {
  channel
    .push(type, msg)
    .receive("ok", console.log)
    .receive("error", (resp) => console.log("Unable to push", resp));
}

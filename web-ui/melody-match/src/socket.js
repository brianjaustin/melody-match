import { Socket } from "phoenix";

let socket = null;

let channel = null;

let gameState = 0;

let callback = null;

function state_update(st) {
  console.log("State updated")
  console.log(st)
  gameState = st;
  if (callback) {
    console.log("Running Callback")
    callback(st);
  }
}
export function ch_join_lobby(user_id, token) {
  console.log(user_id)
  socket = new Socket("ws://localhost:4000/socket", {
    params: { token: "" },
  });
  socket.connect();
  channel = socket.channel(`matchmaker:${user_id}`, {token: token});
  channel
    .join()
    .receive("ok", state_update)
    .receive("error", (resp) => console.log("Unable to join matchmaker channel", resp));
  channel.on("matchFound", state_update);
}
export function ch_start(match_id, token) {
  if (channel == null){
      console.log("CREATING NEW SOCKET")
      socket = new Socket("ws://localhost:4000/socket", {
        params: { token: "" },
      });
      socket.connect();
  }
  console.log(`TRYING TO JOIN CHAT CHANNEL WITH MATCH ID ${match_id}`)
  channel = socket.channel(`chat:${match_id}`, {token: token});
  channel
    .join()
    .receive("ok", state_update("Joined Chat"))
    .receive("error", (resp) => console.log("Unable to join chat channel", resp));
  channel.on("receiveChatMessage", state_update);
  channel.on("chatUserLeft", console.log)
}

export function ch_join(cb) {
  console.log(gameState);
  callback = cb;
  callback(gameState);
}

export function ch_push(type, msg) {
  channel
    .push(type, msg)
    .receive("ok", state_update)
    .receive("error", (resp) => console.log("Unable to push", resp));
}

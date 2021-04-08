import { createStore, combineReducers } from "redux";

function users(state = [], action) {
  switch (action.type) {
    case "users/set":
      return action.data;
    default:
      return state;
  }
}

function user_form(state = {}, action) {
  switch (action.type) {
    case "user_form/set":
      return action.data;
    default:
      return state;
  }
}

function tracks(state= [], action){
    switch (action.type) {
      case "tracks/set":
        return action.data;
      default:
        return state;
    }
}

function matches(state = [], action) {
  switch (action.type) {
    case "matches/set":
      return action.data;
    default:
      return state;
  }
}

function root_reducer(state, action) {
  console.log("root_reducer", state, action);
  let reducer = combineReducers({
    users,
    user_form,
    tracks,
    matches
  });
  return reducer(state, action);
}

let store = createStore(root_reducer);
export default store;

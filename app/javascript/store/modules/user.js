import axios from "axios";

const namespaced = true;

const state = {
  currentUser: undefined,
}

const getters = {
  getCurrentUser(state) {
    return state.currentUser;
  },
}

const mutations = {
  setCurrentUser(state, user) {
    state.currentUser = user;
  },
}

const actions = {
  setCurrentUserAction({ commit }) {
    axios.get("/api/current_user").then((res) => {
      commit("setCurrentUser", res.data);
    });
  },
  logoutAction({ commit }) {
    commit("setCurrentUser", undefined);
  }
}

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters
}
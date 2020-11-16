const namespaced = true

const state = {
  toggleStatus: false
}

const getters = {
  getToggleStatus(state) {
    return state.toggleStatus;
  }
}

const mutations = {
  setToggleStatus(state) {
    state.toggleStatus = !state.toggleStatus;
  },
  setToggleClose(state) {
    state.toggleStatus = false;
  }
}

const actions = {
  setToggleStatusAction({ commit }) {
    commit("setToggleStatus");
  },
  setToggleCloseAction({ commit }) {
    commit("setToggleClose");
  },
}

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters
}
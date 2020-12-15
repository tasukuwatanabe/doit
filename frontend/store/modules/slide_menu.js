const namespaced = true;

const state = {
  toggleStatus: false,
};

const getters = {
  getToggleStatus(state) {
    return state.toggleStatus;
  },
};

const mutations = {
  setToggleStatus(state) {
    state.toggleStatus = !state.toggleStatus;
  },
};

const actions = {
  setToggleStatusAction({ commit }) {
    commit('setToggleStatus');
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

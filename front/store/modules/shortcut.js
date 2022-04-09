const namespaced = true;

const state = {
  shortcuts: [],
};

const getters = {
  getShortcuts(state) {
    return state.shortcuts;
  },
};

const mutations = {
  setShortcuts(state, shortcuts) {
    state.shortcuts = shortcuts;
  },
};

const actions = {
  setShortcutsAction({ commit }, shortcuts) {
    commit('setShortcuts', shortcuts);
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

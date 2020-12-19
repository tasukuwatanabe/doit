import store from '../index';

const namespaced = true;

const state = {
  currentUser: {},
};

const getters = {
  getCurrentUser(state) {
    return state.currentUser;
  },
};

const mutations = {
  setCurrentUser(state, user) {
    state.currentUser = user;
  },
};

const actions = {
  setCurrentUserAction({ commit }, userObj) {
    commit('setCurrentUser', userObj);
  },
  logoutAction({ commit }) {
    commit('setCurrentUser', {});
    store.dispatch('date/resetSelectedDateAction');
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

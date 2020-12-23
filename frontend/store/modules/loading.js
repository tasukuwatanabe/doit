const namespaced = true;

const state = {
  loadingCount: 0,
};

const getters = {
  getLoadingCount(state) {
    return state.loadingCount;
  },
};

const mutations = {
  addLoadingCount(state) {
    state.loadingCount++;
  },
  subtractLoadingCount(state) {
    state.loadingCount--;
  },
};

const actions = {
  addLoadingCountAction({ commit }) {
    commit('addLoadingCount');
  },
  subtractLoadingCountAction({ commit }) {
    commit('subtractLoadingCount');
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

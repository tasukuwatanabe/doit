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

export default {
  namespaced,
  state,
  mutations,
  getters,
};

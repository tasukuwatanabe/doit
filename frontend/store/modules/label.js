const namespaced = true;

const state = {
  labels: [],
};

const getters = {
  getLabels(state) {
    return state.labels;
  },
};

const mutations = {
  setLabels(state, labels) {
    state.labels = labels;
  },
};

const actions = {
  setLabelsAction({ commit }, labels) {
    commit('setLabels', labels);
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

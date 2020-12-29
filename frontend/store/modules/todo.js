const namespaced = true;

const state = {
  todos: [],
};

const getters = {
  getTodos(state) {
    return state.todos;
  },
};

const mutations = {
  setTodos(state, todos) {
    state.todos = todos;
  },
};

const actions = {
  setTodosAction({ commit }, todos) {
    commit('setTodos', todos);
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

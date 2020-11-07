import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    current_user: null,
    logged_in: false,
    selected_date: null,
    selected_format_date: null,
    previous_date: null,
    next_date: null,
    day: null
  },
  mutations: {
    fetchDate(state, data) {
      state.selected_date = data.selected_date;
      state.selected_format_date = data.selected_format_date;
      state.previous_date = data.previous_date;
      state.next_date = data.next_date;
      state.day = data.day;
    },
    login(state, user) {
      state.current_user = user;
      state.logged_in = true;
    },
    logout(state) {
      state.current_user = null;
      state.logged_in = false;
    }
  },
  actions: {
    fetchDateAction({ commit }, date) {
      axios
        .get(`/api/todos`, { params: { date: date } })
        .then((res) => res.data)
        .then((date_array) => commit("fetchDate", date_array));
    },
    loginAction({ commit }) {
      axios
        .post(`/api/guest_login`)
        .then((res) => res.data)
        .then((user) => {
          commit("login", user);

          axios
            .get(`/api/todos`)
            .then((res) => res.data)
            .then((date_array) => {
              commit("fetchDate", date_array);
            });
        });
    },
    logoutAction({ commit }) {
      axios
        .delete(`/api/logout`)
        .then((res) => res.data)
        .then(() => commit("logout"));
    }
  }
});

export default store;

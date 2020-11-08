import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    isLoggedIn: false,
    selected_date: null,
    selected_format_date: null,
    previous_date: null,
    next_date: null,
    day: null
  },

  mutations: {
    isLoggedIn(state) {
      state.isLoggedIn = true;
    },
    isLoggedOut(state) {
      state.isLoggedIn = false;
    }
    // fetchDate(state, data) {
    //   state.selected_date = data.selected_date;
    //   state.selected_format_date = data.selected_format_date;
    //   state.previous_date = data.previous_date;
    //   state.next_date = data.next_date;
    //   state.day = data.day;
    // },
    // login(state, user) {
    //   state.logged_in = true;
    // },
    // logout(state) {
    //   state.logged_in = false;
    // }
  },
  actions: {
    isLoggedInAction({ commit }) {
      return axios.get(`/api/logged_in`).then((res) => {
        if (res.data.state === "Logged in") {
          commit("isLoggedIn");
        } else {
          commit("isLoggedOut");
        }
      });
    }
  }
});

// a

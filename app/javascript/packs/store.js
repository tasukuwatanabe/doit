import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);
// aaaaaaxxea
const store = new Vuex.Store({
  state: {
    isLoggedIn: false,
    selectedDate: null
  },

  getters: {
    isLoggedIn(state) {
      return state.isLoggedIn;
    },
    selectedDate(state) {
      return state.selectedDate;
    }
  },

  mutations: {
    isLoggedIn(state) {
      state.isLoggedIn = true;
    },
    isLoggedOut(state) {
      state.isLoggedIn = false;
      state.selectedDate = null;
    },
    setDate(state, date) {
      state.selectedDate = date;
    }
  },
  actions: {
    setDateAction({ commit, state }, select) {
      let set_date = state.selectedDate
        ? new Date(state.selectedDate)
        : new Date();
      if (select === "next") {
        set_date.setDate(set_date.getDate() + 1);
      } else if (select === "previous") {
        set_date.setDate(set_date.getDate() - 1);
      }

      commit("setDate", set_date);
    },
    isLoggedInAction({ commit }) {
      return axios.get(`/api/logged_in`).then((res) => {
        if (res.data.state === "Logged in") {
          commit("isLoggedIn");
        } else {
          commit("isLoggedOut");
        }
      });
    }
  },
  plugins: [createPersistedState({ storage: window.sessionStorage })]
});

export default store;

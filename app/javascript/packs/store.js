import Vue from "vue";
import Vuex from "vuex";
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    selectedDate: undefined,
    cookieStatus: undefined
  },

  getters: {
    selectedDate(state) {
      return state.selectedDate;
    },
    formatDate(state) {
      const year = state.selectedDate.getFullYear();
      const month = state.selectedDate.getMonth() + 1;
      const date = state.selectedDate.getDate();

      return `${year}-${month}-${date}`;
    },
    cookieStatus(state) {
      return state.cookieStatus;
    }
  },
  mutations: {
    setDate(state, date) {
      state.selectedDate = date;
    },
    clearDate(state) {
      state.selectedDate = undefined;
    },
    checkCookie(state, status) {
      state.cookieStatus = status;
    }
  },
  actions: {
    setDateAction({ commit, state }, set_date) {
      let selected_date;
      if (set_date) {
        selected_date = new Date(set_date);
      } else if (state.selectedDate) {
        selected_date = new Date(state.selectedDate);
      } else {
        selected_date = new Date();
      }
      commit("setDate", selected_date);
    },
    clearDateAction({ commit }) {
      commit("clearDate");
    },
    checkCookieAction({ commit }) {
      const cookie = document.cookie.replace(
        /(?:(?:^|.*;\s*)user_id\s*\=\s*([^;]*).*$)|^.*$/,
        "$1"
      );
      const cookieStatus = () => {
        return cookie != "" && cookie != undefined;
      };
      commit("checkCookie", cookieStatus());
    }
  },
  plugins: [createPersistedState({ storage: window.sessionStorage })]
});

export default store;

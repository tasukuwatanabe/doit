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

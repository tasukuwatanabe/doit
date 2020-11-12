import Vue from "vue";
import Vuex from "vuex";
import createPersistedState from "vuex-persistedstate";
import axios from "axios";

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    selectedDate: undefined,
    cookieStatus: undefined,
    currentUser: {
      id: undefined,
      username: undefined,
      email: undefined,
      user_image: undefined
    },
    toggleStatus: false
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
    },
    getCurrentUser(state) {
      return state.currentUser;
    },
    getToggleStatus(state) {
      return state.toggleStatus;
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
    },
    setCurrentUser(state, user) {
      state.currentUser = user;
    },
    setToggleStatus(state) {
      state.toggleStatus = !state.toggleStatus;
    },
    setToggleClose(state) {
      state.toggleStatus = false;
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
    },
    async currentUserAction({ commit }) {
      await axios.get("/api/current_user").then((res) => {
        let user;
        if (res.data != null) {
          user = {
            id: res.data.id,
            username: res.data.username,
            email: res.data.email,
            user_image: res.data.user_image
          };
        } else {
          user = null;
        }
        commit("setCurrentUser", user);
      });
    },
    setToggleStatusAction({ commit }) {
      commit("setToggleStatus");
    },
    setToggleCloseAction({ commit }) {
      commit("setToggleClose");
    }
  },
  plugins: [createPersistedState({ storage: window.sessionStorage })]
});

export default store;

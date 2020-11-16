import Vue from "vue";
import Vuex from "vuex";
import { date, user, slideMenu } from './modules/index';
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    date,
    user,
    slideMenu
  },
  plugins: [
    createPersistedState({
      paths: ['date'],
    }),
  ],
});
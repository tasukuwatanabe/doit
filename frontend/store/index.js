import Vue from 'vue/dist/vue.esm.js';
import Vuex from 'vuex';
import { date, user, slideMenu, request } from './modules/index';
import createPersistedState from 'vuex-persistedstate';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    date,
    user,
    slideMenu,
    request,
  },
  plugins: [
    createPersistedState({
      paths: ['date'],
    }),
  ],
});

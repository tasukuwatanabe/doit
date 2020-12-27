import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import { date, user, slideMenu, loading } from './modules/index';
import createPersistedState from 'vuex-persistedstate';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    date,
    user,
    slideMenu,
    loading,
  },
  plugins: [
    createPersistedState({
      paths: ['date'],
    }),
  ],
});

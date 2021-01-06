import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import {
  todo,
  shortcut,
  label,
  user,
  date,
  slideMenu,
  loading,
} from './modules/index';
import createPersistedState from 'vuex-persistedstate';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    todo,
    shortcut,
    label,
    user,
    date,
    slideMenu,
    loading,
  },
  plugins: [
    createPersistedState({
      paths: ['date'],
    }),
  ],
});

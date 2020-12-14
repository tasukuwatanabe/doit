// Vueの読み込み
import Vue from 'vue/dist/vue.esm';
import App from '../app';

// Vue.js起動時に、コンソールにヒントが表示されなくなる
Vue.config.productionTip = false;

// vue-router
import VueRouter from 'vue-router';
Vue.use(VueRouter);
import router from '../router/router';

// Font Awesome
import '@fortawesome/fontawesome-free/js/all';

// application.scss
import '../stylesheets/style.scss';

// Flash
import FlashMessage from '@smartweb/vue-flash-message';
Vue.use(FlashMessage);

// axios
import axios from 'axios';

// storeの読み込み
import store from '../store/index';

// Rails-APIを叩く際のaxiosのcors対策
const url =
  process.env.NODE_ENV === 'production'
    ? 'https://doit-app.com/api/v1'
    : 'http://localhost:3000/api/v1';
axios.defaults.baseURL = url;
axios.defaults.withCredentials = true;

// axiosのキャンセルトークンの発行
axios.interceptors.request.use(
  function (config) {
    const source = axios.CancelToken.source();

    config.cancelToken = source.token;

    store.commit('request/addCancelToken', source);

    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
);

new Vue({
  store,
  router,
  render: (h) => h(App),
}).$mount('#app');

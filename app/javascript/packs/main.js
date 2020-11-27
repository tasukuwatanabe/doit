require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
// require("channels");
require("jquery");

// Vueの読み込み
import Vue from 'vue/dist/vue.esm.js'
import App from "../App";

// Vue.js起動時に、コンソールにヒントが表示されなくなる
Vue.config.productionTip = false

// vue-router
import VueRouter from 'vue-router'
Vue.use(VueRouter);
import router from "../router/router";

// Font Awesome
import "@fortawesome/fontawesome-free/js/all";
global.FontAwesome.config.mutateApproach = "sync";

// Bootstrapのスタイルシート側の機能を読み込む
import "bootstrap/dist/css/bootstrap.min.css";
// BootstrapのJavaScript側の機能を読み込む
import "bootstrap";
// application.scss
import "../stylesheets/style.scss";

// loading icon
import Vuesax from 'vuesax';
import 'vuesax/dist/vuesax.css';
Vue.use(Vuesax);

// Flash
import FlashMessage from '@smartweb/vue-flash-message';
Vue.use(FlashMessage);

// コンポーネントの読み込み・登録
import LoadingIcon from "../components/shared/loading-icon";
Vue.component("v-loading-icon", LoadingIcon);

// axios
import axios from "axios";

// storeの読み込み
import store from "../store/index";

// Rails-APIを叩く際のaxiosのcors対策
axios.defaults.baseURL = "http://localhost:3000";
axios.defaults.withCredentials = true;

// axiosのキャンセルトークンの発行
const axiosCancelation = () => {
  axios.interceptors.request.use(function (config) {
    let source = axios.CancelToken.source();

    config.cancelToken = source.token;

    store.commit('request/addCancelToken', source);

    return config;
  }, function (error) {
    return Promise.reject(error);
  });
}

new Vue({
  store,
  router,
  render: h => h(App),
}).$mount('#app')
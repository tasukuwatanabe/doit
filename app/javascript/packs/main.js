require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("jquery");

// Vueの読み込み
import Vue from "vue/dist/vue.esm.js";

// vue-router
import router from "../router/router";

// Font Awesome
import "@fortawesome/fontawesome-free/js/all";
global.FontAwesome.config.mutateApproach = "sync";

// application.scss
import "../stylesheets/application";

// loading icon
import Vuesax from 'vuesax';
import 'vuesax/dist/vuesax.css';
Vue.use(Vuesax);

// Flash
import FlashMessage from '@smartweb/vue-flash-message';
Vue.use(FlashMessage);

// コンポーネントの読み込み
import Header from "../components/shared/v-header.vue";
import Footer from "../components/shared/v-footer.vue";
import SidebarLeft from "../components/shared/sidebar-left.vue";
import SidebarRight from "../components/shared/sidebar-right.vue";
import SlideMenu from "../components/shared/slide-menu.vue";
import Flash from "../components/shared/flash.vue";
import LoadingIcon from "../components/shared/loading-icon.vue";

// グローバルコンポーネントの登録
Vue.component("v-header", Header);
Vue.component("v-footer", Footer);
Vue.component("v-slide-menu", SlideMenu);
Vue.component("v-sidebar-left", SidebarLeft);
Vue.component("v-sidebar-right", SidebarRight);
Vue.component("v-flash", Flash);
Vue.component("v-loading-icon", LoadingIcon);

// axios
import axios from "axios";

// storeの読み込み
import store from "../store/index";

// axiosのキャンセルトークンの発行
axios.interceptors.request.use(function (config) {
  let source = axios.CancelToken.source();

  config.cancelToken = source.token;

  store.commit('request/addCancelToken', source);

  return config;
}, function (error) {
  return Promise.reject(error);
});

const app = new Vue({
  el: "#app",
  store,
  router
});

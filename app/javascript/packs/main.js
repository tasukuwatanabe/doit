require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("jquery");

import "@fortawesome/fontawesome-free/js/all";
global.FontAwesome.config.mutateApproach = "sync";

require("bootstrap");
import "../stylesheets/application";

import "bootstrap/dist/css/bootstrap.css";

import Vue from "vue/dist/vue.esm.js";
import Router from "../router/router";
import Header from "../components/shared/v-header.vue";
import Footer from "../components/shared/v-footer.vue";
import SidebarLeft from "../components/shared/sidebar-left.vue";
import SidebarRight from "../components/shared/sidebar-right.vue";
import SlideMenu from "../components/shared/slide-menu.vue";
import Flash from "../components/shared/flash.vue";
import FlashMessage from '@smartweb/vue-flash-message';
import axios from "axios";
import store from "../store/index";

Vue.use(FlashMessage);

Vue.component("v-header", Header);
Vue.component("v-footer", Footer);
Vue.component("v-slide-menu", SlideMenu);
Vue.component("v-sidebar-left", SidebarLeft);
Vue.component("v-sidebar-right", SidebarRight);
Vue.component("v-flash", Flash);

axios.interceptors.request.use(function (config) {
  let source = axios.CancelToken.source();

  config.cancelToken = source.token;

  store.commit('addCancelToken', source);

  return config;
}, function (error) {
  return Promise.reject(error);
});

const app = new Vue({
  el: "#app",
  store,
  router: Router
});

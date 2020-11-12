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
import store from "./store.js";
import Router from "../router/router";
import Header from "../components/shared/v-header.vue";
import Footer from "../components/shared/v-footer.vue";
import Flash from "../components/shared/v-flash.vue";
import SidebarLeft from "../components/shared/sidebar-left.vue";
import SidebarRight from "../components/shared/sidebar-right.vue";
import SlideMenu from "../components/shared/slide-menu.vue";

Vue.component("v-header", Header);
Vue.component("v-footer", Footer);
Vue.component("slide-menu", SlideMenu);
Vue.component("v-flash", Flash);
Vue.component("sidebar-left", SidebarLeft);
Vue.component("sidebar-right", SidebarRight);

const app = new Vue({
  el: "#app",
  store,
  router: Router
});

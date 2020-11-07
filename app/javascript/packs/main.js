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
import "bootstrap-vue/dist/bootstrap-vue.css";
import BootstrapVue from "bootstrap-vue";

Vue.use(BootstrapVue);

import Vue from "vue/dist/vue.esm.js";
import store from "./store";
import Router from "../router/router";
import Header from "../components/header.vue";
import Footer from "../components/footer.vue";
import SlideMenu from "../components/slide-menu.vue";
import Flash from "../components/flash.vue";
import SidebarLeft from "../components/sidebar_left.vue";
import SidebarRight from "../components/sidebar_right.vue";

var app = new Vue({
  el: "#app",
  store,
  router: Router,
  components: {
    "v-header": Header,
    "v-footer": Footer,
    "slide-menu": SlideMenu,
    "v-flash": Flash,
    "sidebar-left": SidebarLeft,
    "sidebar-right": SidebarRight
  },
  methods: {
    onExecute: function () {
      axios.defaults.xsrfCookieName = "CSRF-TOKEN";
      axios.defaults.xsrfHeaderName = "X-CSRF-Token";
      axios.defaults.withCredentials = true;
    }
  }
});

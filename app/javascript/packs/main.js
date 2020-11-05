require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("jquery");

import "@fortawesome/fontawesome-free/js/all";
global.FontAwesome.config.mutateApproach = "sync";

require("bootstrap");
import "../stylesheets/application";

import Vue from "vue";
import VueRouter from "vue-router";
import Router from "./router.vue";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import BootstrapVue from "bootstrap-vue";

Vue.use(BootstrapVue);
Vue.use(VueRouter);

document.addEventListener("turbolinks:load", () => {
  new Vue(Router).$mount("#app");
});

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
  let apps = [
    { elem: "#todos", object: Router },
    { elem: "#history", object: Router },
    { elem: "#labels", object: Router },
    { elem: "#shortcuts", object: Router },
    { elem: "#user_edit", object: Router },
    { elem: "#password_edit", object: Router }
  ];

  apps.forEach((app) => {
    if ($(app.elem).length) {
      new Vue(app.object).$mount(app.elem);
    }
  });
});

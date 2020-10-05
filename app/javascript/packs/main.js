import Vue from "vue";
import App from "./App.vue";
import Router from "../router/router.js";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import BootstrapVue from "bootstrap-vue";
Vue.use(BootstrapVue);

const app = new Vue({
  el: "#app",
  router: Router,
  render: (h) => h(App)
});

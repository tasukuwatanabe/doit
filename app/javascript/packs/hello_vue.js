import Vue from "vue";
import App from "../app.vue";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import BootstrapVue from "bootstrap-vue";
Vue.use(BootstrapVue);

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    render: (h) => h(App)
  }).$mount();
  // document.body.appendChild(app.$el);

  console.log(app);
});

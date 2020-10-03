import Vue from "vue";
import VueRouter from "vue-router";
import shortcutHome from "../pages/shortcut/shortcutHome.vue";

Vue.use(VueRouter);

const routes = [{ path: "/", name: "shortcutHome", component: shortcutHome }];

export default new VueRouter({ routes });

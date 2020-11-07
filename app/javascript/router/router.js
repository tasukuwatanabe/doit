import Vue from "vue/dist/vue.esm.js";
import VueRouter from "vue-router";
import Todo from "../components/todo.vue";
import History from "../components/history.vue";
import Shortcut from "../components/shortcut.vue";
import Label from "../components/label.vue";
import UserEdit from "../components/user_edit.vue";
import PasswordEdit from "../components/password_edit.vue";
import Login from "../components/login.vue";

Vue.use(VueRouter);

export default new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/",
      component: Todo,
      name: "todos"
    },
    {
      path: "/history",
      component: History,
      name: "history"
    },
    {
      path: "/shortcuts",
      component: Shortcut,
      name: "shortcuts"
    },
    {
      path: "/labels",
      component: Label,
      name: "labels"
    },
    {
      path: "/user/:userId/edit",
      component: UserEdit,
      name: "user_edit"
    },
    {
      path: "/password/:userId/edit",
      component: PasswordEdit,
      name: "password_edit"
    },
    {
      path: "/login",
      component: Login,
      name: "login"
    }
    // { path: "*", component: NotFoundComponent }
  ]
});

export const state = {
  message: "hello vuex"
};

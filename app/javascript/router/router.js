import Vue from "vue/dist/vue.esm.js";
import VueRouter from "vue-router";
import Todo from "../components/todo.vue";
import History from "../components/history.vue";
import Shortcut from "../components/shortcut.vue";
import Label from "../components/label.vue";
import UserEdit from "../components/user_edit.vue";
import PasswordEdit from "../components/password_edit.vue";
import Login from "../components/login.vue";
import store from "../packs/store";
import Vuex from "vuex";

Vue.use(VueRouter);
Vue.use(Vuex);

function isLoggedIn(to, from, next) {
  store.dispatch("isLoggedInAction").then(() => {
    if (store.state.isLoggedIn) {
      next();
    } else {
      next({ path: "/login" });
    }
  });
}

export default new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/",
      component: Todo,
      name: "todos",
      beforeEnter: isLoggedIn()
    },
    {
      path: "/history",
      component: History,
      name: "history",
      beforeEnter: isLoggedIn()
    },
    {
      path: "/shortcuts",
      component: Shortcut,
      name: "shortcuts",
      beforeEnter: isLoggedIn()
    },
    {
      path: "/labels",
      component: Label,
      name: "labels",
      beforeEnter: isLoggedIn()
    },
    {
      path: "/user/:userId/edit",
      component: UserEdit,
      name: "user_edit",
      beforeEnter: isLoggedIn()
    },
    {
      path: "/password/:userId/edit",
      component: PasswordEdit,
      name: "password_edit",
      beforeEnter: isLoggedIn()
    },
    {
      path: "/login",
      component: Login,
      name: "login"
    }
    // { path: "*", component: NotFoundComponent }
  ]
});

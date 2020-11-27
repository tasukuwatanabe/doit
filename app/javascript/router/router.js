import Vue from "vue/dist/vue.esm.js";
import Vuex from "vuex";
import VueRouter from "vue-router";
import Todo from "../components/todo-list";
import Shortcut from "../components/shortcut-list";
import Label from "../components/label-list";
import UserEdit from "../components/user-edit";
import PasswordEdit from "../components/password-edit";
import Login from "../components/login-form";
import Signup from "../components/signup-form";
import Redirect from "../components/redirect";
import PasswordResetNew from "../components/password-reset-new";
import PasswordResetEdit from "../components/password-reset-edit";
import NotFound from "../components/not-found";
import store from "../store/index";
import { cookieStatus, deleteCookie } from "../components/mixins/cookie";

Vue.use(VueRouter);
Vue.use(Vuex);

function isLoggedIn(to, from, next) {
  store.dispatch('request/cancelPendingRequests');
  if (cookieStatus()) {
    next();
  } else {
    deleteCookie();
    next({ path: "/login" });
  }
}

function isLoggedOut(to, from, next) {
  store.dispatch('request/cancelPendingRequests');
  if (cookieStatus()) {
    next({ path: "/" });
  } else {
    next();
  }
}

export default new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/",
      component: Todo,
      name: "todos",
      beforeEnter: isLoggedIn
    },
    {
      path: "/shortcuts",
      component: Shortcut,
      name: "shortcuts",
      beforeEnter: isLoggedIn
    },
    {
      path: "/labels",
      component: Label,
      name: "labels",
      beforeEnter: isLoggedIn
    },
    {
      path: "/user/:userId/edit",
      component: UserEdit,
      name: "user_edit",
      beforeEnter: isLoggedIn
    },
    {
      path: "/password/:userId/edit",
      component: PasswordEdit,
      name: "password_edit",
      beforeEnter: isLoggedIn
    },
    {
      path: "/login",
      component: Login,
      name: "login",
      beforeEnter: isLoggedOut
    },
    {
      path: "/signup",
      component: Signup,
      name: "signup",
      beforeEnter: isLoggedOut
    },
    {
      path: "/password_resets/new",
      component: PasswordResetNew,
      name: "password_resets_new",
      beforeEnter: isLoggedOut
    },
    {
      path: "/password_resets/:id/edit",
      component: PasswordResetEdit,
      name: "password_resets_edit",
      beforeEnter: isLoggedOut
    },
    {
      path: "/redirect",
      component: Redirect,
      name: "redirect"
    },
    {
      path: "*",
      component: NotFound,
      beforeEnter: isLoggedIn
    }
  ]
});

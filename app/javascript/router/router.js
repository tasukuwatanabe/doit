import Vue from "vue/dist/vue.esm.js";
import Vuex from "vuex";
import VueRouter from "vue-router";
import Todo from "../components/todo-list.vue";
import Shortcut from "../components/shortcut-list.vue";
import Label from "../components/label-list.vue";
import UserEdit from "../components/user-edit.vue";
import PasswordEdit from "../components/password-edit.vue";
import Login from "../components/login-form.vue";
import Signup from "../components/signup-form.vue";
import Redirect from "../components/redirect.vue";
import PasswordResetNew from "../components/password-reset-new.vue";
import PasswordResetEdit from "../components/password-reset-edit.vue";
import NotFound from "../components/not-found.vue";
import Store from "../store/index";
import { cookieStatus, deleteCookie } from "../components/mixins/cookie";

Vue.use(VueRouter);
Vue.use(Vuex);

function isLoggedIn(to, from, next) {
  // Store.dispatch("slideMenu/setToggleCloseAction");
  if (cookieStatus()) {
    next();
  } else {
    deleteCookie();
    next({ path: "/login" });
  }
}

function isLoggedOut(to, from, next) {
  // Store.dispatch("slideMenu/setToggleCloseAction");
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
    }
      path: "*",
      component: NotFound,
      beforeEnter: isLoggedIn
    }
  ]
});

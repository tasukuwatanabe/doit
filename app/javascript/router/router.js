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
import Store from "../packs/store";

Vue.use(VueRouter);
Vue.use(Vuex);

function readCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)user_id\s*\=\s*([^;]*).*$)|^.*$/,
    "$1"
  );
}

function login(to, from, next) {
  if (readCookie()) {
    next();
  } else {
    next({ path: "/login" });
  }
}

function logout(to, from, next) {
  if (!readCookie()) {
    Store.dispatch("clearDateAction").then(() => {
      next();
    });
  } else {
    next({ path: "/" });
  }
}

export default new VueRouter({
  mode: "history",
  routes: [
    {
      path: "/",
      component: Todo,
      name: "todos",
      beforeEnter: login
    },
    {
      path: "/shortcuts",
      component: Shortcut,
      name: "shortcuts",
      beforeEnter: login
    },
    {
      path: "/labels",
      component: Label,
      name: "labels",
      beforeEnter: login
    },
    {
      path: "/user/:userId/edit",
      component: UserEdit,
      name: "user_edit",
      beforeEnter: login
    },
    {
      path: "/password/:userId/edit",
      component: PasswordEdit,
      name: "password_edit",
      beforeEnter: login
    },
    {
      path: "/login",
      component: Login,
      name: "login",
      beforeEnter: logout
    },
    {
      path: "/signup",
      component: Signup,
      name: "signup",
      beforeEnter: logout
    }
    // {
    //   path: "/password_resets/new",
    //   component: PasswordNew,
    //   name: "password_resets_new",
    //   beforeEnter: logout
    // },
    // {
    //   path: "/password_resets/:userId/edit",
    //   component: PasswordEdit,
    //   name: "password_resets_edit",
    //   beforeEnter: logout
    // },
    // {
    //   path: "/account_activations/:userId/edit",
    //   component: AccountActivation,
    //   name: "account_activations",
    //   beforeEnter: logout
    // },
    // {
    //   path: "/email_confirmations/:userId/edit",
    //   component: EmailConfirmations,
    //   name: "email_confirmations",
    //   beforeEnter: logout
    // }
    // { path: "*", component: NotFoundComponent }
  ]
});

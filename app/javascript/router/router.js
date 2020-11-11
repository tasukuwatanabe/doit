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
import store from "../packs/store";

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

function isLoggedOut(to, from, next) {
  store.dispatch("isLoggedInAction").then(() => {
    if (!store.state.isLoggedIn) {
      next();
    } else {
      next({ path: "/" });
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
    }
    // {
    //   path: "/password_resets/new",
    //   component: PasswordNew,
    //   name: "password_resets_new",
    //   beforeEnter: isLoggedOut
    // },
    // {
    //   path: "/password_resets/:userId/edit",
    //   component: PasswordEdit,
    //   name: "password_resets_edit",
    //   beforeEnter: isLoggedOut
    // },
    // {
    //   path: "/account_activations/:userId/edit",
    //   component: AccountActivation,
    //   name: "account_activations",
    //   beforeEnter: isLoggedOut
    // },
    // {
    //   path: "/email_confirmations/:userId/edit",
    //   component: EmailConfirmations,
    //   name: "email_confirmations",
    //   beforeEnter: isLoggedOut
    // }
    // { path: "*", component: NotFoundComponent }
  ]
});

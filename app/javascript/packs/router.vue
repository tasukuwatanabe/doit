<template>
  <div class="wrapper">
    <div id="screen-layer"></div>
    <v-header></v-header>
    <slide-menu v-if="logged_in"></slide-menu>
    <v-flash></v-flash>
    <main>
      <div class="container">
        <div class="inner">
          <sidebar-left></sidebar-left>
          <router-view></router-view>
          <sidebar-right v-if="root"></sidebar-right>
        </div>
      </div>
    </main>
    <v-footer></v-footer>
  </div>
</template>

<script>
import axios from "axios";
import VueRouter from "vue-router";
import Header from "../components/header.vue";
import Footer from "../components/footer.vue";
import SlideMenu from "../components/slide-menu.vue";
import Flash from "../components/flash.vue";
import Todo from "../components/todo.vue";
import History from "../components/history.vue";
import Shortcut from "../components/shortcut.vue";
import Label from "../components/label.vue";
import UserEdit from "../components/user_edit.vue";
import PasswordEdit from "../components/password_edit.vue";
import SidebarLeft from "../components/sidebar_left.vue";
import SidebarRight from "../components/sidebar_right.vue";
import Login from "../components/login.vue";

const router = new VueRouter({
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

export default {
  components: {
    "v-header": Header,
    "v-footer": Footer,
    "slide-menu": SlideMenu,
    "v-flash": Flash,
    "sidebar-left": SidebarLeft,
    "sidebar-right": SidebarRight
  },
  data() {
    return {
      currentUser: {}
    };
  },
  mounted() {
    axios
      .get("/api/current_user")
      .then((response) => (this.currentUser = response.data[0]));
  },
  computed: {
    root() {
      return this.$route.path === "/";
    },
    logged_in() {
      return this.currentUser !== null;
    }
  },
  router: router
};

$(function() {
  $("#hamburger, #screen-layer, #slide-menu a").click(function() {
    $("body").toggleClass("menu-open");
  });
});
</script>

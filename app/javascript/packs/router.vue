<template>
  <div class="wrapper">
    <sidebar-left></sidebar-left>
    <router-view></router-view>
    <sidebar-right v-if="todos"></sidebar-right>
  </div>
</template>

<script>
import VueRouter from "vue-router";
import Todo from "../components/todo.vue";
import History from "../components/history.vue";
import Shortcut from "../components/shortcut.vue";
import Label from "../components/label.vue";
import UserEdit from "../components/user_edit.vue";
import PasswordEdit from "../components/password_edit.vue";
import SidebarLeft from "../components/sidebar_left.vue";
import SidebarRight from "../components/sidebar_right.vue";

const router = new VueRouter({
  mode: "history",
  routes: [
    { path: "/", component: Todo },
    { path: "/history", component: History },
    { path: "/shortcuts", component: Shortcut },
    { path: "/labels", component: Label },
    {
      path: "/user/:userId/edit",
      component: UserEdit,
      name: "user_edit"
    },
    {
      path: "/password/:userId/edit",
      component: PasswordEdit,
      name: "password_edit"
    }
  ]
});

export default {
  components: {
    "sidebar-left": SidebarLeft,
    "sidebar-right": SidebarRight
  },
  computed: {
    todos() {
      return this.$route.path === "/";
    }
  },
  router: router
};
</script>

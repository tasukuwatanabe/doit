<template>
  <div id="app">
    <v-header></v-header>
    <v-slide-menu></v-slide-menu>
    <main>
      <v-flash></v-flash>
      <div class="container inner">
        <v-sidebar-left></v-sidebar-left>
        <router-view></router-view>
        <v-sidebar-right></v-sidebar-right>
      </div>
    </main>
    <v-footer></v-footer>
  </div>
</template>

<script>
import Header from "./components/shared/v-header.vue";
import Footer from "./components/shared/v-footer.vue";
import SidebarLeft from "./components/shared/sidebar-left.vue";
import SidebarRight from "./components/shared/sidebar-right.vue";
import SlideMenu from "./components/shared/slide-menu.vue";
import Flash from "./components/shared/flash.vue";

export default {
  components: {
    'v-header': Header,
    'v-footer': Footer,
    'v-sidebar-left': SidebarLeft,
    'v-sidebar-right': SidebarRight,
    'v-slide-menu': SlideMenu,
    'v-flash': Flash
  }
}
</script>
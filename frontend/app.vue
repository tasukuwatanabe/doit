<template>
  <div id="app" class="wrapper">
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
import Header from "./components/shared/v-header";
import Footer from "./components/shared/v-footer";
import SidebarLeft from "./components/shared/sidebar-left";
import SidebarRight from "./components/shared/sidebar-right";
import SlideMenu from "./components/shared/slide-menu";
import Flash from "./components/shared/flash";

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
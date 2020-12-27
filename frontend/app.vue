<template>
  <div id="app" class="wrapper">
    <Header />
    <SlideMenu v-if="userLoggedIn" />
    <main>
      <Flash />
      <div class="container inner">
        <SidebarLeft v-if="userLoggedIn" />
        <router-view></router-view>
        <SidebarRight v-if="isTodo" />
      </div>
    </main>
    <Footer></Footer>
    <Loading v-if="this.getLoadingCount" />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import Header from "./components/shared/header";
import Footer from "./components/shared/footer";
import SidebarLeft from "./components/shared/sidebar-left";
import SidebarRight from "./components/shared/sidebar-right";
import SlideMenu from "./components/shared/slide-menu";
import Flash from "./components/shared/flash";
import Loading from "./components/shared/loading";

export default {
  components: {
    Header,
    Footer,
    SidebarLeft,
    SidebarRight,
    SlideMenu,
    Flash,
    Loading
  },
  computed: {
    ...mapGetters({
      getLoadingCount: "loading/getLoadingCount"
    }),
    isTodo() {
      return this.$route.name === 'todos';
    },
    userLoggedIn() {
      return (this.$route.name !== 'login') &&
             (this.$route.name !== 'signup') &&
             (this.$route.name !== 'password_resets_new') &&
             (this.$route.name !== 'password_resets_edit')
    },
  }
}
</script>
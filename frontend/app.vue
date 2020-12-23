<template>
  <div id="app" class="wrapper" :class="{'loading-open': this.getLoadingCount }">
    <Header />
    <SlideMenu />
    <main>
      <Flash />
      <div class="container inner">
        <SidebarLeft />
        <router-view></router-view>
        <SidebarRight />
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
    })
  }
}
</script>
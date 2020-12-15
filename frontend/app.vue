<template>
  <div id="app" class="wrapper">
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
  </div>
</template>

<script>
import Header from "./components/shared/header";
import Footer from "./components/shared/footer";
import SidebarLeft from "./components/shared/sidebar-left";
import SidebarRight from "./components/shared/sidebar-right";
import SlideMenu from "./components/shared/slide-menu";
import Flash from "./components/shared/flash";

export default {
  components: {
    Header,
    Footer,
    SidebarLeft,
    SidebarRight,
    SlideMenu,
    Flash
  }
}
</script>
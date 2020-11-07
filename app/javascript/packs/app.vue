<script>
import axios from "axios";
import Header from "../components/header.vue";
import Footer from "../components/footer.vue";
import SlideMenu from "../components/slide-menu.vue";
import Flash from "../components/flash.vue";
import SidebarLeft from "../components/sidebar_left.vue";
import SidebarRight from "../components/sidebar_right.vue";
import Login from "../components/login.vue";

export default {
  components: {
    "v-header": Header,
    "v-footer": Footer,
    "slide-menu": SlideMenu,
    "v-flash": Flash,
    "sidebar-left": SidebarLeft,
    "sidebar-right": SidebarRight
  }
};
</script>

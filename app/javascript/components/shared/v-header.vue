<template>
  <header class="header">
    <div class="container">
      <div v-if="this.getCurrentUser" class="header__inner">
        <router-link :to="{ name: 'todos' }" class="header__logo">
          <img src="/doit-logo-white.png" alt="DoITロゴ" />
        </router-link>
        <div @click="toggleSlide" id="hamburger" class="hamburger">
          <span class="hamburger__line"></span>
          <span class="hamburger__line"></span>
          <span class="hamburger__line"></span>
        </div>
      </div>
      <div v-else class="header__inner">
        <router-link :to="{ name: 'login' }" class="header__logo">
          <img src="/doit-logo-white.png" alt="DoITロゴ" />
        </router-link>
      </div>
    </div>
  </header>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    })
  },
  methods: {
    ...mapActions({
      setToggleStatusAction: "slideMenu/setToggleStatusAction"
    }),
    toggleSlide() {
      this.setToggleStatusAction();
    }
  }
};
</script>

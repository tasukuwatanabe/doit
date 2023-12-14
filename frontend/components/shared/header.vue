<template>
  <header class="header">
    <div class="container">
      <div v-if="this.getCurrentUser" class="header__inner">
        <router-link :to="{ name: 'todos' }" class="header__logo">
          <img src="../../images/logo/logo-white.png" alt="DoITロゴ" />
        </router-link>
        <div v-if="userLoggedIn" @click="toggleSlide" id="hamburger" class="hamburger">
          <span class="hamburger__line"></span>
          <span class="hamburger__line"></span>
          <span class="hamburger__line"></span>
        </div>
      </div>
      <div v-else class="header__inner">
        <router-link :to="{ name: 'login' }" class="header__logo">
          <img src="../../images/logo/logo-white.png" alt="DoITロゴ" />
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
    }),
    userLoggedIn() {
      return (this.$route.name !== 'login') &&
             (this.$route.name !== 'signup') &&
             (this.$route.name !== 'password_resets_new') &&
             (this.$route.name !== 'password_resets_edit')
    }
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

<style lang="scss" scoped>
@import "../../stylesheets/variables.scss";

.header {
  background-color: $color-main-theme;
  position: relative;

  &__inner {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px 0;
    min-height: 65px;

    @media (max-width: 991px) {
      padding: 15px 0;
    }
  }

  &__logo {
    display: inline-block;

    img {
      height: 30px;
      width: auto;
    }
  }

  &__userinfo {
    @media (max-width: 991px) {
      display: none !important;
    }
  }
}

.hamburger {
  position: absolute;
  right: 20px;
  width: 25px;
  top: 0;
  bottom: 0;
  z-index: 98;
  display: flex;
  flex-direction: column;
  justify-content: center;
  cursor: pointer;

  @media (min-width: 992px) {
    display: none;
  }

  &__line {
    width: 100%;
    height: 3px;
    display: block;
    margin: 2px 0;
    background-color: #ffffff;
  }
}
</style>
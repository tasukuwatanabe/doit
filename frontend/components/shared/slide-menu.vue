<template>
  <div>
    <aside
      id="slide-menu"
      class="slide-menu"
      :class="{ 'is-open': this.getToggleStatus }"
    >
      <div class="sidebar-left__userinfo userinfo">
        <router-link
          :to="{
            name: 'user_edit',
            params: { userId: this.getCurrentUser.id }
          }"
          @click.native="toggleSlide"
          class="userinfo__link"
        >
          <div class="userinfo__username">
            {{ this.getCurrentUser.username }}
          </div>
        </router-link>
      </div>
      <nav class="nav">
        <ul class="nav__list">
          <li class="nav__item">
            <router-link :to="{ name: 'todos' }"
                          @click.native="toggleSlide"
                          class="nav__link">
              <span class="icon nav__icon">
                <i class="fas fa-calendar-check"></i>
              </span>
              <span>ToDoリスト</span>
            </router-link>
          </li>
          <li class="nav__item">
            <router-link :to="{ name: 'shortcuts' }"
                          @click.native="toggleSlide"
                          class="nav__link">
              <span class="icon nav__icon">
                <i class="fas fa-share"></i>
              </span>
              <span>ショートカット</span>
            </router-link>
          </li>
          <li class="nav__item">
            <router-link :to="{ name: 'labels' }"
                          @click.native="toggleSlide"
                          class="nav__link">
              <span class="icon nav__icon">
                <i class="fas fa-tag"></i>
              </span>
              <span>ラベル</span>
            </router-link>
          </li>
          <li class="nav__item">
            <router-link
              :to="{
                name: 'user_edit',
                params: { userId: this.getCurrentUser.id }
              }"
              @click.native="toggleSlide"
              class="nav__link"
            >
              <span class="icon nav__icon">
                <i class="fas fa-cog"></i>
              </span>
              <span>アカウント設定</span>
            </router-link>
          </li>
          <li class="nav__item">
            <router-link
              :to="{
                name: 'password_edit',
                params: { userId: this.getCurrentUser.id }
              }"
              @click.native="toggleSlide"
              class="nav__link"
            >
              <span class="icon nav__icon">
                <i class="fas fa-key"></i>
              </span>
              <span>パスワード設定</span>
            </router-link>
          </li>
          <li class="nav__item">
            <div @click="logout" class="nav__link" id="logout">
              <span class="icon nav__icon">
                <i class="fas fa-sign-out-alt"></i>
              </span>
              <span>ログアウト</span>
            </div>
          </li>
        </ul>
      </nav>
    </aside>
    <div
      @click="toggleSlide"
      id="screen-layer"
      v-if="this.getToggleStatus"
    ></div>
  </div>
</template>

<script>
import { axiosForBackend } from "../../config/axios";
import { mapGetters, mapActions } from "vuex";
import Logout from "../mixins/logout";
import Flash from "../mixins/flash";

export default {
  mixins: [Logout, Flash],
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser",
      getToggleStatus: "slideMenu/getToggleStatus"
    })
  },
  methods: {
    ...mapActions({
      logoutAction: 'user/logoutAction',
      setToggleStatusAction: "slideMenu/setToggleStatusAction",
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    fetchUser() {
      axiosForBackend
        .get("/users/current")
        .then((res) => {
          this.setCurrentUserAction(res.data);
        })
        .catch(error => {
          this.forceLogout(error);
        });
    },
    toggleSlide() {
      this.setToggleStatusAction();
    },
    logout() {
      axiosForBackend.delete("/logout").then((res) => {
        this.logoutAction();
        this.toggleSlide();
        this.$router.push({ name: "login" });
        const message = "ログアウトしました";
        this.generateFlash('success', message);
      });
    }
  }
};
</script>

<style lang="scss" scoped>
$width-slide-menu: 270px;

#screen-layer {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 99;
  background-color: rgba(0, 0, 0, 0.7);
  transition-duration: 0.5s;
}

.slide-menu {
  width: $width-slide-menu;
  background-color:#fafbfc;;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: 100;
  transform: translateX($width-slide-menu * -1);
  transition-duration: 0.1s;
  padding: 30px 15px 30px 30px;

  &.is-open {
    transform: translateX(0);
  }

  .userinfo {
    margin-bottom: 20px;
  }
}
</style>

<template>
  <aside
    class="sidebar sidebar-left">
    <div class="sidebar--stickey sidebar-left__inner">
      <div class="sidebar-left__userinfo userinfo">
        <router-link
          :to="{
            name: 'user_edit',
            params: { userId: this.getCurrentUser.id }
          }"
          class="userinfo__link"
        >
          <div>
            <img
              :alt="this.getCurrentUser.username + ' アイコン'"
              class="profile-img"
              :src="userImageWithNumber"
            />
          </div>
          <div class="userinfo__username">
            {{ this.getCurrentUser.username }}
          </div>
        </router-link>
      </div>
      <nav class="nav">
        <ul class="nav__list">
          <li class="nav__item">
            <router-link :to="{ name: 'todos' }" class="nav__link">
              <span class="icon nav__icon">
                <i class="fas fa-calendar-check"></i>
              </span>
              <span>ToDoリスト</span>
            </router-link>
          </li>
          <li class="nav__item">
            <router-link :to="{ name: 'shortcuts' }" class="nav__link">
              <span class="icon nav__icon">
                <i class="fas fa-share"></i>
              </span>
              <span>ショートカット</span>
            </router-link>
          </li>
          <li class="nav__item">
            <router-link :to="{ name: 'labels' }" class="nav__link">
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
              class="nav__link"
            >
              <span class="icon nav__icon">
                <i class="fas fa-key"></i>
              </span>
              <span>パスワード設定</span>
            </router-link>
          </li>
          <li class="nav__item">
            <div @click="logout" class="nav__link">
              <span class="icon nav__icon">
                <i class="fas fa-sign-out-alt"></i>
              </span>
              <span>ログアウト</span>
            </div>
          </li>
        </ul>
      </nav>
    </div>
  </aside>
</template>

<script>
import { axiosForBackend } from "../../config/axios";
import { mapGetters, mapActions } from "vuex";
import Logout from "../mixins/logout";
import Flash from "../mixins/flash";

export default {
  created() {
    this.fetchUser();
  },
  mixins: [Logout, Flash],
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
    userImageWithNumber() {
      if (this.getCurrentUser.user_image) {
        return this.getCurrentUser.user_image.url + '?' + Math.random();
      }
    }
  },
  methods: {
    ...mapActions({
      logoutAction: 'user/logoutAction',
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
    logout() {
      axiosForBackend
        .delete("/logout")
        .then((res) => {
          this.logoutAction();
          this.$router.push({ name: "login" });
          const message = "ログアウトしました";
          this.generateFlash('success', message);
        });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "../../stylesheets/variables.scss";
@import "../../stylesheets/mixin.scss";

.sidebar-left {
  width: 250px;
  @media (max-width: 991px) {
    display: none;
  }

  &__inner {
    background-color: #fff;
    padding: 25px 22px 10px;
    box-shadow: $box-shadow-common;
    min-height: 448px;
  }

  &__userinfo {
    margin-bottom: 15px;
  }
}
</style>
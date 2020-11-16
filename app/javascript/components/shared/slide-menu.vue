<template>
  <div>
    <aside
      v-if="this.getCurrentUser"
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
          class="userinfo__link"
        >
          <img
            alt="ゲストユーザーアイコン"
            class="profile-img"
            src="/user_images/default.jpg"
          />
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
                <svg width="20px" height="20px">
                  <g
                    transform="translate(10.000000, 10.000000) scale(-1, 1) translate(-10.000000, -10.000000)"
                  >
                    <path
                      d="M7.85447699,4.30359833 L7.85447699,0.713891213 C7.85435146,0.319497908 7.53456067,-3.6959034e-08 7.14016736,-3.6959034e-08 C6.93790795,-3.6959034e-08 6.74518828,0.0858995816 6.60979079,0.236150628 L0.183054393,7.37702929 C-0.0519665272,7.63878661 -0.0613807531,8.03267782 0.160920502,8.30535565 L6.58769874,16.1602929 C6.83740586,16.465523 7.28728033,16.5105439 7.5925523,16.2608368 C7.75790795,16.1255649 7.85401674,15.9233473 7.85447699,15.7097071 L7.85447699,12.1514226 C13.4957741,12.3349372 17.0161925,14.7464017 18.6029289,19.5065272 C18.700251,19.7977406 18.9728452,19.9942296 19.2798745,19.9942296 C19.3183682,19.9942296 19.3568619,19.9912134 19.3948536,19.9849372 C19.7402929,19.9285774 19.9939749,19.6301674 19.9939749,19.2801255 C19.9939749,10.871046 14.9317992,4.6934728 7.85447699,4.30359833 Z"
                    ></path>
                  </g>
                </svg>
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
            <div @click="logout()" class="nav__link" id="logout">
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
      @click="toggleSlide()"
      id="screen-layer"
      v-if="this.getToggleStatus"
    ></div>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapActions } from "vuex";

export default {
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser",
      getToggleStatus: "slideMenu/getToggleStatus"
    })
  },
  methods: {
    ...mapActions({
      setToggleStatusAction: "slideMenu/setToggleStatusAction",
      logoutAction: "user/logoutAction"
    },),
    toggleSlide() {
      this.setToggleStatusAction();
    },
    logout() {
      axios.delete("/api/logout").then(() => {
        this.logoutAction();
        this.$router.push({ name: "login" });
      });
    }
  }
};
</script>

<template>
  <div class="login">
    <div class="login__title">パスワードリセット</div>
    <div class="login__inner">
      <form class="form">
        <div class="form__group">
          <label class="form__label">新しいパスワード</label>
          <input
            class="form__input"
            type="password"
            v-model="password"
            autocomplete="on"
          />
        </div>
        <div class="form__group">
          <label class="form__label">新しいパスワード(確認用)</label>
          <input
            class="form__input"
            type="password"
            v-model="password_confirmation"
            autocomplete="on"
          />
        </div>
        <div class="form__group text-center">
          <div
            @click="submitPasswordReset()"
            class="btn-main btn-main--password-reset btn--sm"
          >
            パスワードをリセットする
          </div>
        </div>
        <ul class="form__linkList form__linkList--password-reset">
          <li class="form__linkItem">
            お試しの方は
            <a @click="guestLogin()" class="form__link--default">
              ゲストログイン
            </a>
          </li>
          <li class="form__linkItem">
            アカウントをお持ちの方は
            <router-link :to="{ name: 'login' }" class="form__link--default">
              ログイン
            </router-link>
          </li>
        </ul>
      </form>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      password: "",
      password_confirmation: ""
    };
  },
  methods: {
    guestLogin() {
      axios.post("/api/guest_login").then(() => {
        this.$router.push({ name: "todos" });
      });
    },
    submitPasswordReset() {
      if (this.password == "") {
        alert("パスワードは必須です");
        return;
      } else if (this.password_confirmation == "") {
        alert("パスワード(確認用)は必須です");
        return;
      }

      const password_reset_params = {
        password: this.password,
        password_confirmation: this.password_confirmation
      };

      axios
        .put("/api/password_resets/:id", {
          user: password_reset_params,
          id: this.$route.query.id,
          email: this.$route.query.email
        })
        .then(() => {
          this.$router.push({ name: "todos" });
        });
    }
  }
};
</script>

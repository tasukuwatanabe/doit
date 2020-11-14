<template>
  <div class="login">
    <div class="login__title">パスワードリセット</div>
    <div class="login__inner">
      <form class="form">
        <div class="form__group">
          <label class="form__label">メールアドレス</label>
          <input class="form__input" type="email" v-model="email" />
        </div>
        <div class="form__group text-center">
          <div
            @click="submitPasswordReset()"
            class="btn-main btn-main--password-reset btn--sm"
          >
            再設定用のメールを発行
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
      email: ""
    };
  },
  methods: {
    guestLogin() {
      axios.post("/api/guest_login").then(() => {
        this.$router.push({ name: "todos" });
      });
    },
    submitPasswordReset() {
      axios
        .post("/api/password_resets", {
          password_reset_form: { email: this.email }
        })
        .then(() => {
          this.$router.push({ name: "login" });
        });
    }
  }
};
</script>

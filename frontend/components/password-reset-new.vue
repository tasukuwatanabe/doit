<template>
  <div class="login">
    <div class="login__case">
      <div class="login__title">パスワードリセット</div>
      <div class="login__inner">
        <form class="form" @submit.prevent="submitPasswordReset">
          <div class="form__group">
            <label class="form__label">メールアドレス</label>
            <input class="form__input" type="email" v-model="email" />
            <span class="form__error" v-if="errors.email">
              {{ errors.email }}
            </span>
          </div>
          <div class="text-center">
            <button type="submit" class="btn btn--main btn--md">
              再設定用のメールを発行
            </button>
          </div>
          <ul class="form__linkList form__linkList--password-reset">
            <li class="form__linkItem">
              <GuestLogin />
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
  </div>
</template>

<script>
import axiosForBackend from "../config/axios";
import { mapActions } from "vuex";
import GuestLogin from './shared/guest-login.vue';
import Flash from "./mixins/flash";

export default {
  data() {
    return {
      email: "",
      errors: {
        email: ""
      }
    };
  },
  mixins: [Flash],
  components: {
    GuestLogin
  },
  methods: {
    submitPasswordReset() {
      axiosForBackend
        .post("/password_resets", {
          password_reset_form: { email: this.email }
        })
        .then((res) => {
          this.$router.push({ name: "login" });
          this.generateFlash('success', res.data.message);
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    }
  }
};
</script>
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
import axios from "axios";
import GuestLogin from './guest-login.vue';

export default {
  data() {
    return {
      email: "",
      errors: {
        email: ""
      }
    };
  },
  components: {
    GuestLogin
  },
  methods: {
    submitPasswordReset() {
      axios
        .post("/password_resets", {
          password_reset_form: { email: this.email }
        })
        .then((res) => {
          this.$router.push({ name: "login" });
          this.flashMessage.success({
            title: res.data.message,
            time: 5000,
            icon: '/icons/success.svg',
          });
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    }
  }
};
</script>
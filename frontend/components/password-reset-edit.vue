<template>
  <div class="login">
    <div class="login__case">
      <div class="login__title">パスワードリセット</div>
      <div class="login__inner">
        <form class="form">
          <span class="form__error form__error--base" v-if="!!errors.base">
            {{ errors.base }}
          </span>
          <div class="form__group">
            <label class="form__label">新しいパスワード</label>
            <input
              class="form__input"
              type="password"
              v-model="password"
              autocomplete="on"
            />
            <span class="form__error" v-if="!!errors.password">
              {{ errors.password }}
            </span>
          </div>
          <div class="form__group">
            <label class="form__label">新しいパスワード(確認用)</label>
            <input
              class="form__input"
              type="password"
              v-model="password_confirmation"
              autocomplete="on"
            />
            <span class="form__error" v-if="!!errors.password_confirmation">
              {{ errors.password_confirmation }}
            </span>
          </div>
          <div class="form__group text-center">
            <div
              @click="submitPasswordReset"
              class="btn-main btn-main--password-reset btn--sm"
            >
              パスワードをリセットする
            </div>
          </div>
          <ul class="form__linkList form__linkList--password-reset">
            <li class="form__linkItem">
              お試しの方は
              <a @click="guestLogin" class="form__link--default">
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
  </div>
</template>

<script>
import axios from "axios";
import GuestLogin from "./mixins/guest-login";

export default {
  data() {
    return {
      password: "",
      password_confirmation: "",
      errors: ""
    };
  },
  mixins: [GuestLogin],
  methods: {
    submitPasswordReset() {
      const password_reset_params = {
        password: this.password,
        password_confirmation: this.password_confirmation
      };

      axios
        .put(`/api/password_resets/${this.$route.params.id}`, {
          user: password_reset_params,
          email: this.$route.query.email
        })
        .then((res) => {
          this.$router.push({ name: "todos" });
          this.flashMessage.success({
            title: res.data.message,
            time: 5000,
            icon: 'assets/images/icons/success.svg',
          });
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
          if (!!error.response.data.message) {
            this.flashMessage.error({
              title: error.response.data.message,
              icon: 'assets/images/icons/error.svg',
            });
            this.$router.push({ name: 'password_resets_new' })
          }
        });
    }
  }
};
</script>

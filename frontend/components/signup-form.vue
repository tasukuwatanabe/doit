<template>
  <div class="login">
    <div class="login__case">
      <div class="login__title">新規登録</div>
      <div class="login__inner">
        <form class="form" @submit.prevent="submitRegister">
          <div class="form__group">
            <label class="form__label">ユーザー名</label>
            <input class="form__input" type="text" v-model="username" />
            <span class="form__error" v-if="errors.username">
              {{ errors.username }}
            </span>
          </div>
          <div class="form__group">
            <label class="form__label">メールアドレス</label>
            <input class="form__input" type="email" v-model="email" />
            <span class="form__error" v-if="errors.email">
              {{ errors.email }}
            </span>
          </div>
          <div class="form__group">
            <label class="form__label">パスワード</label>
            <input
              class="form__input"
              type="password"
              v-model="password"
              autocomplete="on" />
            <span class="form__error" v-if="errors.password">
              {{ errors.password }}
            </span>
          </div>
          <div class="form__group">
            <label class="form__label">パスワード(確認用)</label>
            <input
              class="form__input"
              type="password"
              v-model="password_confirmation"
              autocomplete="on"
            />
            <span class="form__error" v-if="errors.password_confirmation">
              {{ errors.password_confirmation }}
            </span>
          </div>
          <div class="text-center">
            <button
              type="submit"
              class="btn btn--main btn--md"
            >
              新規登録
            </button>
          </div>
          <ul class="form__linkList form__linkList--login">
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
import { axiosForBackend } from "../config/axios";
import GuestLogin from './shared/guest-login.vue';
import Flash from "./mixins/flash";

export default {
  data() {
    return {
      username: "",
      email: "",
      password: "",
      password_confirmation: "",
      errors: ""
    };
  },
  mixins: [Flash],
  components: {
    GuestLogin
  },
  methods: {
    submitRegister() {
      const user_params = {
        username: this.username,
        email: this.email,
        password: this.password,
        password_confirmation: this.password_confirmation
      };
      axiosForBackend
        .post("/users", { user: user_params })
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

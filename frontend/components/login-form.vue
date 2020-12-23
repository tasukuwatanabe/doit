<template>
  <div class="login">
    <div class="login__case">
      <div class="login__title">ログイン</div>
      <div class="login__inner">
        <form class="form" @submit.prevent="submitLogin">
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
              autocomplete="on"
            />
            <span class="form__error" v-if="errors.password">
              {{ errors.password }}
            </span>
            <router-link
              :to="{ name: 'password_resets_new' }"
              class="form__reset-link"
            >
              パスワード再設定
            </router-link>
          </div>
          <div class="text-center">
            <button type="submit" class="btn btn--main btn--md">
              ログインする
            </button>
          </div>
          <ul class="form__linkList form__linkList--login">
            <li class="form__linkItem">
              <GuestLogin />
            </li>
            <li class="form__linkItem">
              初めての方は
              <router-link :to="{ name: 'signup' }" class="form__link--default">
                新規登録
              </router-link>
            </li>
          </ul>
          <OmniauthLogin />
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axiosForBackend from "../config/axios";
import { mapActions } from "vuex";
import GuestLogin from './shared/guest-login.vue';
import OmniauthLogin from './shared/omniauth-login.vue';
import UploadHost from "./mixins/upload_host";
import Flash from "./mixins/flash";

export default {
  data() {
    return {
      email: "",
      password: "",
      errors: ""
    };
  },
  components: {
    GuestLogin,
    OmniauthLogin
  },
  mixins: [UploadHost, Flash],
  methods: {
    ...mapActions({
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    submitLogin() {
      const session_params = {
        email: this.email,
        password: this.password
      };
      axiosForBackend
        .post("/login", { session: session_params })
        .then((res) => {
          this.setCurrentUserAction(res.data.user);
          this.$router.push({ name: "todos" });
          this.generateFlash('success', res.data.message);
        })
        .catch((error) => {
          const base_error = error.response.data.errors.base;
          if (base_error) {
            this.generateFlash('error', base_error);
          }
          this.errors = error.response.data.errors;
        });
    }
  }
};
</script>
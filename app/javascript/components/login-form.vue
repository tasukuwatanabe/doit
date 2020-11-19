<template>
  <div class="login">
    <div class="login__title">ログイン</div>
    <div class="login__inner">
      <form class="form">
        <span class="form__error form__error--base" v-if="!!errors.base">
          {{ errors.base }}
        </span>
        <div class="form__group">
          <label class="form__label">メールアドレス</label>
          <input class="form__input" type="email" v-model="email" />
          <span class="form__error" v-if="!!errors.email">
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
          <span class="form__error" v-if="!!errors.password">
            {{ errors.password }}
          </span>
          <router-link
            :to="{ name: 'password_resets_new' }"
            class="form__reset-link"
          >
            パスワード再設定
          </router-link>
        </div>
        <div class="form-group text-center">
          <div @click="submitLogin()" class="btn-main btn-main--login btn--md">
            ログイン
          </div>
        </div>
        <ul class="form__linkList form__linkList--login">
          <li class="form__linkItem">
            お試しの方は
            <a @click="guestLogin()" class="form__link--default">
              ゲストログイン
            </a>
          </li>
          <li class="form__linkItem">
            初めての方は
            <router-link :to="{ name: 'signup' }" class="form__link--default">
              新規登録
            </router-link>
          </li>
        </ul>
        <div class="sns-login">
          <p class="sns-login__title">SNSでログイン</p>
          <ul class="sns-login__list">
            <li class="sns-login__item">
              <a href="/auth/facebook" class="sns-icon sns-icon--facebook">
                <i class="fab fa-facebook-f"></i>
              </a>
            </li>
            <li class="sns-login__item">
              <a href="/auth/twitter" class="sns-icon sns-icon--twitter">
                <i class="fab fa-twitter"></i>
              </a>
            </li>
            <li class="sns-login__item">
              <a href="/auth/google_oauth2" class="sns-icon sns-icon--google">
                <i class="fab fa-google"></i>
              </a>
            </li>
          </ul>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import GuestLogin from "./mixins/guest-login";
import { mapActions } from "vuex";

export default {
  data() {
    return {
      email: undefined,
      password: undefined,
      errors: ""
    };
  },
  mixins: [GuestLogin],
  methods: {
    ...mapActions({
      setCurrentUserAction: 'user/setCurrentUserAction'
    }),
    submitLogin() {
      const session_params = {
        email: this.email,
        password: this.password
      };
      axios
        .post("/api/login", { session: session_params })
        .then((res) => {
          this.$router.push({ name: "todos" });
          this.flashMessage.success({
            title: res.data.message,
            icon: '/flash/success.svg',
          });

          axios.get("/api/current_user").then((res) => {
            this.setCurrentUserAction(res.data);
          });
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    }
  }
};
</script>

<template>
  <div class="login">
    <div class="login__title">新規登録</div>
    <div class="login__inner">
      <form class="form">
        <div class="form__group">
          <label class="form__label">ユーザー名</label>
          <input class="form__input" type="text" v-model="username" />
        </div>
        <div class="form__group">
          <label class="form__label">メールアドレス</label>
          <input class="form__input" type="email" v-model="email" />
        </div>
        <div class="form__group">
          <label class="form__label">パスワード</label>
          <input class="form__input" type="email" v-model="password" />
        </div>
        <div class="form__group">
          <label class="form__label">パスワード(確認用)</label>
          <input
            class="form__input"
            type="email"
            v-model="password_confirmation"
          />
        </div>
        <div class="form-group text-center">
          <div class="btn-main btn-main--login btn--md">新規登録</div>
        </div>
        <ul class="form__linkList form__linkList--login">
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
        <div class="sns-login">
          <p class="sns-login__title">SNSで新規登録</p>
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

export default {
  data() {
    return {
      user: {
        username: undefined,
        email: undefined,
        password: undefined,
        password_confirmation: undefined
      }
    };
  },
  methods: {
    guestLogin() {
      axios.post("/api/guest_login").then((response) => {
        this.$router.push({ name: "todos" });
      });
    }
  }
};
</script>

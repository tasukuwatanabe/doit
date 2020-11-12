<template>
  <div class="login">
    <div class="login__title">ログイン</div>
    <div class="login__inner">
      <form class="form">
        <div class="form__group">
          <label class="form__label">メールアドレス</label>
          <input class="form__input" type="email" v-model="user.email" />
        </div>
        <div class="form__group">
          <label class="form__label">パスワード</label>
          <input class="form__input" type="email" v-model="user.password" />
          <a class="form__reset-link">パスワード再設定</a>
        </div>
        <div class="form-group text-center">
          <div class="btn-main btn-main--login btn--md">ログイン</div>
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

export default {
  data() {
    return {
      user: {
        email: undefined,
        password: undefined
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

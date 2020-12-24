<template>
  <div class="content">
    <div class="headline">
      <div class="headline__title">
        パスワードの変更
        <span class="icon headline__icon">
          <i class="fas fa-cog"></i>
        </span>
      </div>
      <p class="headline__text">
        ログインに必要なパスワードを変更することができます。
      </p>
    </div>
    <form @submit.prevent="submitPassword" class="form user-form">
      <div v-if="isGuest" class="form__group">
        <div class="guest-message">
          <i class="fas fa-exclamation-triangle"></i>
          ゲストユーザーはパスワードを変更することはできません
        </div>
      </div>
      <div class="form__group">
        <label class="form__label">新しいパスワード</label>
        <input
          class="form__input"
          type="password"
          v-model="password"
          autocomplete="on"
          :readonly="isGuest"
        />
        <span class="form__error" v-if="errors.password">
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
          :readonly="isGuest"
        />
        <span class="form__error" v-if="errors.password_confirmation">
          {{ errors.password_confirmation }}
        </span>
      </div>
      <div class="form__action">
        <button type="submit" class="btn btn--main btn--md">
          更新する
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import { axiosForBackend } from "../config/axios";
import { mapGetters, mapActions } from "vuex";
import Flash from "./mixins/flash";

export default {
  data() {
    return {
      password: "",
      password_confirmation: "",
      errors: {}
    };
  },
  mixins: [Flash],
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser",
    }),
    isGuest() {
      if (this.getCurrentUser) {
        return this.getCurrentUser.email === 'guest@example.com';
      }
    },
  },
  methods: {
    ...mapActions({
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    clearErrors() {
      this.errors = {};
    },
    clearFormValue() {
      this.password = "";
      this.password_confirmation = "";
    },
    submitPassword() {
      const password_params = {
        password: this.password,
        password_confirmation: this.password_confirmation
      };
      axiosForBackend
        .put(`/users/${this.getCurrentUser.id}/password`, {
          change_password_form: password_params
        })
        .then((res) => {
          this.setCurrentUserAction(res.data);
          const message = "パスワードが更新されました";
          this.generateFlash('success', message);
          this.clearFormValue();
          this.clearErrors();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    }
  }
};
</script>
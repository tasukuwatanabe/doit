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
     <div class="spinner-border text-info" v-if="loading" role="status">
      <span class="sr-only">Loading...</span>
    </div>
    <form v-show="!loading" class="form user-form">
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
          :readonly="isGuest"
        />
        <span class="form__error" v-if="!!errors.password_confirmation">
          {{ errors.password_confirmation }}
        </span>
      </div>
      <div class="form__action">
        <div @click="submitPassword" class="btn-main btn--sm">
          パスワードを更新する
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters } from "vuex";

export default {
  data() {
    return {
      password: "",
      password_confirmation: "",
      errors: "",
      loading: ''
    };
  },
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
    submitPassword() {
      const password_params = {
        password: this.password,
        password_confirmation: this.password_confirmation
      };
      this.loading = true;
      axios
        .put(`/api/users/${this.getCurrentUser.id}/password`, {
          change_password_form: password_params
        })
        .then((res) => {
          this.flashMessage.success({
            title: res.data.message,
            time: 5000,
            icon: 'assets/images/icons/success.svg',
          });
          this.password = "";
          this.password_confirmation = "";
          this.errors = "";
          this.loading = false;
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
          this.loading = false;
        });
    }
  }
};
</script>

<style scoped>
.loading-case {
  width: 600px;
  height: 350px;
}
</style>
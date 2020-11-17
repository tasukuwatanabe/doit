<template>
  <div>
    <div class="container inner">
      <v-sidebar-left></v-sidebar-left>
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
        <form action="" class="form user-form">
          <div class="form__group">
            <label class="form__label">新しいパスワード</label>
            <input
              class="form__input"
              type="password"
              v-model="new_password"
              autocomplete="on"
            />
            <span class="form__error" v-if="!!errors.new_password">
              {{ errors.new_password }}
            </span>
          </div>
          <div class="form__group">
            <label class="form__label">新しいパスワード(確認用)</label>
            <input
              class="form__input"
              type="password"
              v-model="new_password_confirmation"
              autocomplete="on"
            />
            <span class="form__error" v-if="!!errors.new_password_confirmation">
              {{ errors.new_password_confirmation }}
            </span>
          </div>
          <div class="form__action">
            <div @click="submitPassword()" class="btn-main btn--sm">
              パスワードを更新する
            </div>
          </div>
        </form>
      </div>
      <v-sidebar-right></v-sidebar-right>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters } from "vuex";

export default {
  data() {
    return {
      new_password: "",
      new_password_confirmation: "",
      errors: ""
    };
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    })
  },
  methods: {
    submitPassword() {
      const password_params = {
        new_password: this.new_password,
        new_password_confirmation: this.new_password_confirmation
      };
      axios
        .put(`/api/users/${this.getCurrentUser.id}/password`, {
          change_password_form: password_params
        })
        .then((res) => {
          this.flashMessage.success({
            title: res.data.message,
            time: 0,
            icon: '/flash/success.svg',
          });
          this.new_password = "";
          this.new_password_confirmation = "";
          this.errors = "";
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    }
  }
};
</script>

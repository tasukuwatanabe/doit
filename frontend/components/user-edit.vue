<template>
  <div class="content">
    <div class="headline">
      <div class="headline__title">
        アカウント設定
        <span class="icon headline__icon">
          <i class="fas fa-cog"></i>
        </span>
      </div>
      <p class="headline__text">
        ユーザー名、メールアドレスなどのユーザー情報を変更することができます。
      </p>
    </div>
    <form @submit.prevent="submitUser" class="form user-form" >
      <div v-if="isGuest" class="form__group">
        <div class="guest-message">
          <i class="fas fa-exclamation-triangle"></i>
          ゲストユーザーはユーザー情報を変更することはできません
        </div>
      </div>
      <div class="form__group">
        <label class="form__label">ユーザー名</label>
        <input type="text"
                v-model="username"
                class="form__input"
                :readonly="isGuest" />
        <span class="form__error" v-if="errors.username">
          {{ errors.username }}
        </span>
      </div>
      <div class="form__group">
        <label class="form__label">メールアドレス</label>
        <input type="email"
                v-model="email"
                class="form__input"
                :readonly="isGuest" />
        <span class="form__error" v-if="errors.unconfirmed_email">
          {{ errors.unconfirmed_email }}
        </span>
        <p class="form__desc">
          アドレスを変更すると、確認のため新しいアドレスにメールを送信します。<strong
            >新しいアドレスは確認が完了するまで有効化されません。</strong
          >
        </p>
        <div v-if="unconfirmed_email" class="form__notice">
          <code>{{ unconfirmed_email }}</code>へのメールアドレス変更が承認待ちです。
          <a @click="cancelEmailConfirmation" class="link--default">キャンセル</a>
        </div>
      </div>
      <div class="form__action">
        <button type="submit" class="btn btn--main btn--md">更新する</button>
        <div @click="showCancelPopup"
              class="form__cancel"
              :class="{ 'disabled' : isGuest }"
              :disabled="isGuest">退会する</div>
      </div>
    </form>
    <AccountCancelModal ref="accountCancelModal" />
  </div>
</template>

<script>
import { axiosForBackend } from "../config/axios";
import { mapGetters, mapActions } from "vuex";
import Flash from "./mixins/flash";
import AccountCancelModal from "./shared/account-cancel-modal";

export default {
  data() {
    return {
      id: "",
      username: "",
      email: "",
      unconfirmed_email: "",
      errors: ""
    };
  },
  components: {
    AccountCancelModal
  },
  mixins: [Flash],
  created() {
    this.setUserData();
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
    isGuest() {
      return this.email === 'guest@example.com';
    }
  },
  methods: {
    ...mapActions({
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    setUserData() {
      this.id = this.getCurrentUser.id;
      this.username = this.getCurrentUser.username;
      this.email = this.getCurrentUser.email;
      this.unconfirmed_email = this.getCurrentUser.unconfirmed_email;
    },
    submitUser() {
      this.errors = "";
      let formData = new FormData();
      formData.append("user[username]", this.username);
      formData.append("user[email]", this.email);

      axiosForBackend
        .put(`/users/${this.id}`, formData)
        .then((res) => {
          this.$refs.file.value = '';
          this.file = '';
          this.setCurrentUserAction(res.data.user);
          this.setUserData();
          this.generateFlash('success', res.data.message);
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
          this.generateFlash('error', "更新に失敗しました");
        });
    },
    cancelEmailConfirmation() {
      axiosForBackend.delete(`/email_confirmations/${this.id}`).then((res) => {
        this.setCurrentUserAction(res.data.user);
        this.setUserData();
        this.generateFlash('success', res.data.message);
      });
    },
    showCancelPopup() {
      if (this.isGuest) {
        return;
      }
      this.$refs.accountCancelModal.toggleModalStatus();
    }
  }
};
</script>

<style lang="scss" scoped>
@import "../stylesheets/variables.scss";
@import "../stylesheets/mixin.scss";

.form {
  input[type="file"] {
    font-size: 0.9em;
    width: 100%;
    white-space: initial;
    word-wrap: break-word;
  }
  &__cancel {
    cursor: pointer;
    user-select: none;

    &.disabled {
      opacity: .5;
      cursor: default;
    }
  }
}

.link {
  &--default {
    color: $color-main-theme;
    text-decoration: underline;
  }
}
</style>

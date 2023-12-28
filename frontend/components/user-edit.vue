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
      <!-- <div class="form__group">
        <label class="form__label">SNS連携</label>
        <table class="sns-link__table">
          <tr>
            <td>Facebook</td>
            <td>
              <div class="sns-icon sns-icon--facebook">
                <i class="fab fa-facebook-f"></i>
              </div>
            </td>
            <td>
              <div v-if="facebook_uid != null">
                <span v-if="auto_generated_password">連携中</span>
                <a v-else @click="cancelOauth('facebook')" class="link--default">連携を解除</a>
              </div>
              <span v-else>未連携</span>
            </td>
          </tr>
          <tr>
            <td>Twitter</td>
            <td>
              <div class="sns-icon sns-icon--twitter">
                <i class="fab fa-twitter"></i>
              </div>
            </td>
            <td>
              <div v-if="twitter_uid != null">
                <span v-if="auto_generated_password">連携中</span>
                <a v-else @click="cancelOauth('twitter')" class="link--default">連携を解除</a>
              </div>
              <span v-else>未連携</span>
            </td>
          </tr>
          <tr>
            <td>Google</td>
            <td>
              <div class="sns-icon sns-icon--google">
                <i class="fab fa-google"></i>
              </div>
            </td>
            <td>
              <div v-if="google_uid != null">
                <span v-if="auto_generated_password">連携中</span>
                <a v-else @click="cancelOauth('google_oauth2')" class="link--default">連携を解除</a>
              </div>
              <span v-else>未連携</span>
            </td>
          </tr>
        </table>
        <div v-if="auto_generated_password">
          <p>
            SNS連携を解除するには
            <router-link
              :to="{
                name: 'password_edit',
                params: { userId: id }
              }"
              class="link--default"
              >パスワードを設定</router-link
            >してください
          </p>
        </div>
      </div> -->
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
      facebook_uid: "",
      twitter_uid: "",
      google_uid: "",
      unconfirmed_email: "",
      auto_generated_password: "",
      file: "",
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
      this.facebook_uid = this.getCurrentUser.facebook_uid;
      this.twitter_uid = this.getCurrentUser.twitter_uid;
      this.google_uid = this.getCurrentUser.google_uid;
      this.unconfirmed_email = this.getCurrentUser.unconfirmed_email;
      this.auto_generated_password = this.getCurrentUser.auto_generated_password;
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
    cancelOauth(provider) {
      axiosForBackend.delete("/auth/" + provider).then((res) => {
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

.sns-link {
  &__table {
    margin-top: 0.5em;
    margin-bottom: 1em;

    td {
      padding: 10px 30px 10px 0;
    }
  }
}

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

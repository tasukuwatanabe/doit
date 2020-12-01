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
    <form class="form user-form">
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
        <span class="form__error" v-if="!!errors.username">
          {{ errors.username }}
        </span>
      </div>
      <div class="form__group">
        <label class="form__label">メールアドレス</label>
        <input type="email"
                v-model="email"
                class="form__input"
                :readonly="isGuest" />
        <span class="form__error" v-if="!!errors.unconfirmed_email">
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
      <div class="form__group">
        <label class="form__label">プロフィール画像</label>
        <div class="form__profile-box">
          <img
            :alt="username + 'のプロフィール画像'"
            :src="user_image_with_number"
            class="profile-img"
          />
          <input type="file"
                  ref="file"
                  :disabled="isGuest"
                  @change="onImageUpload" />
        </div>
        <div v-if="has_user_image" class="form__profile-default">
          <input
            type="checkbox"
            v-model="remove_user_image"
            id="remove_user_image" 
            :disabled="isGuest"
            true-value="1" />
          <label for="remove_user_image" 
                  :disabled="isGuest">デフォルトの画像を使用</label>
        </div>
      </div>
      <div class="form__group">
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
                <a v-else @click="cancelOauth('google')" class="link--default">連携を解除</a>
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
      </div>
      <div class="form__action">
        <div @click="submitUser" class="btn-main btn--md">変更する</div>
        <a @click="accountCancel" 
            class="form__cancel" 
            :class="{ 'form__cancel--disabled' : isGuest }"
            :disabled="isGuest">退会する</a>
      </div>
    </form>
  </div>
</template>

<script>
import Vue from 'vue/dist/vue.esm.js'
import axios from "axios";
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      id: "",
      username: "",
      email: "",
      user_image: "",
      facebook_uid: "",
      twitter_uid: "",
      google_uid: "",
      file: "",
      unconfirmed_email: "",
      auto_generated_password: "",
      remove_user_image: "",
      errors: "",
      message: "",
      random_number: "",
    };
  },
  created() {
    this.loading = true;
    this.random_number =  Math.random();
    this.setUserData();
  },
  watch: {
    getCurrentUser: function() {
      this.setUserData();
    }
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
    isGuest() {
      if (this.getCurrentUser) {
        return this.getCurrentUser.email === 'guest@example.com';
      }
    },
    has_user_image() {
      return this.user_image !== "/user_images/default.jpg";
    },
    user_image_with_number() {
      if (this.user_image) {
        return this.user_image + '?' + this.random_number;
      }
    }
  },
  methods: {
    ...mapActions({
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    setUserData() {
      if (this.getCurrentUser != null) {
        this.id = this.getCurrentUser.id;
        this.username = this.getCurrentUser.username;
        this.email = this.getCurrentUser.email;
        this.user_image = this.getCurrentUser.user_image.url;
        this.facebook_uid = this.getCurrentUser.facebook_uid;
        this.twitter_uid = this.getCurrentUser.twitter_uid;
        this.google_uid = this.getCurrentUser.google_uid;
        this.unconfirmed_email = this.getCurrentUser.unconfirmed_email;
        this.auto_generated_password = this.getCurrentUser.auto_generated_password;
        this.remove_user_image = this.getCurrentUser.remove_user_image;
      }
      this.loading = false;
    },
    async cancelEmailConfirmation() {
      this.loading = true;
      await axios.delete(`/api/email_confirmations/${this.id}`).then((res) => {
        this.flashMessage.success({
          title: res.data.message,
          time: 5000,
          icon: '/icons/success.svg',
        });
      });
      await axios.get("/api/current_user").then((res) => {
        this.setCurrentUserAction(res.data);
        this.loading = false;
      });
    },
    onImageUpload: function (e) {
      this.file = this.$refs.file.files[0];
      const image = new Image();
      const reader = new FileReader();
      let vm = this;

      reader.onload = (e) => {
        vm.image = e.target.result;
      };
      reader.readAsDataURL(this.file);
    },
    submitUser() {
      this.loading = true;
      this.errors = "";
      let formData = new FormData();
      formData.append("user[username]", this.username);
      formData.append("user[email]", this.email);
      if (this.remove_user_image === "1") {
        formData.append("user[remove_user_image]", this.remove_user_image);
      }
      if (this.file != undefined) {
        formData.append("user[user_image]", this.file);
      }

      axios
        .put(`/api/users/${this.id}`, formData, {
          headers: {
            "Content-Type": "application/json"
          }
        })
        .then((res) => {
          this.$refs.file.value = null;
          this.random_number =  Math.random();
          this.setCurrentUserAction(res.data.user);
          this.flashMessage.success({
            title: res.data.message,
          time: 5000,
            icon: '/icons/success.svg',
          });
          this.loading = false;
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
          this.loading = false;
        });
    },
    async cancelOauth(provider) {
      this.loading = true;
      await axios.delete("/cancel_oauth/" + provider).then((res) => {
          this.flashMessage.success({
            title: res.data.message,
          time: 5000,
            icon: '/icons/success.svg',
          });
        });
      await axios.get("/api/current_user").then((res) => {
        this.setCurrentUserAction(res.data);
        this.loading = false;
      });
    },
    accountCancel() {
      if (this.isGuest) {
        return;
      }
      this.loading = true;
      axios
        .delete(`/api/users/${this.id}`)
        .then((res) => {
          this.$router.push({ name: "login" });
          this.flashMessage.success({
            title: res.data.message,
            time: 5000,
            icon: '/icons/success.svg',
          });
          this.loading = false;
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "../stylesheets/variables.scss";

.sns-link {
  &__table {
    margin-top: 0.5em;
    margin-bottom: 1em;

    td {
      padding: 10px 30px 10px 0;
    }
  }

  &__cancel {
    margin-left: 1em;
  }
}

.loading-case {
  width: 600px;
  height: 350px;
}

.link {
  &--default {
    color: $color-main-theme;
    text-decoration: underline;
  }
}
</style>
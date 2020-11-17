<template>
  <div>
    <div class="container inner" v-if="user">
      <v-sidebar-left></v-sidebar-left>
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
          <div class="form__group">
            <label class="form__label">ユーザー名</label>
            <input type="text" v-model="user.username" class="form__input" />
            <span class="form__error" v-if="!!errors.username">
              {{ errors.username }}
            </span>
          </div>
          <div class="form__group">
            <label class="form__label">メールアドレス</label>
            <input type="email" v-model="user.email" class="form__input" />
            <span class="form__error" v-if="!!errors.unconfirmed_email">
              {{ errors.unconfirmed_email }}
            </span>
            <p class="form__desc">
              アドレスを変更すると、確認のため新しいアドレスにメールを送信します。<strong
                >新しいアドレスは確認が完了するまで有効化されません。</strong
              >
            </p>
            <div v-if="user && user.unconfirmed_email" class="form__notice">
              <code>{{ user.unconfirmed_email }}</code
              >へのメールアドレス変更が承認待ちです。
              <a @click="cancelEmailConfirmation()" class="link--default"
                >キャンセル</a
              >
            </div>
          </div>
          <div class="form__group">
            <label class="form__label">プロフィール画像</label>
            <div class="form__profile-box">
              <img
                :alt="user.username + 'のプロフィール画像'"
                :src="user_image_with_number"
                class="profile-img"
              />
              <input type="file" ref="file" @change="onImageUpload" />
            </div>
            <div v-if="has_user_image" class="form__profile-default">
              <input
                type="checkbox"
                v-model="user.remove_user_image"
                id="remove_user_image"
                true-value="1"
              />
              <label for="remove_user_image">デフォルトの画像を使用</label>
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
                  <span
                    v-if="
                      user.facebook_uid != null &&
                      user.auto_generated_password === true
                    "
                    >連携中</span
                  >
                  <a
                    v-else-if="user.facebook_uid != null"
                    @click="cancelOauth('Facebook')"
                    class="link--default"
                    >連携を解除</a
                  >
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
                  <span
                    v-if="
                      user.twitter_uid != null &&
                      user.auto_generated_password === true
                    "
                    >連携中</span
                  >
                  <a
                    v-else-if="user.twitter_uid != null"
                    @click="cancelOauth('Twitter')"
                    class="link--default"
                    >連携を解除</a
                  >
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
                  <span
                    v-if="
                      user.google_uid != null &&
                      user.auto_generated_password === true
                    "
                    >連携中</span
                  >
                  <a
                    v-else-if="user.google_uid != null"
                    @click="cancelOauth('Google')"
                    class="link--default"
                    >連携を解除</a
                  >
                  <span v-else>未連携</span>
                </td>
              </tr>
            </table>
            <div v-if="user.auto_generated_password">
              <p>
                SNS連携を解除するには
                <router-link
                  :to="{
                    name: 'password_edit',
                    params: { userId: user.id }
                  }"
                  class="link--default"
                  >パスワードを設定</router-link
                >してください
              </p>
            </div>
          </div>
          <div class="form__action">
            <div @click="submitUser()" class="btn-main btn--md">変更する</div>
            <a
              @click="accountCancel()"
              class="form__cancel"
              :class="{ disable_for_guest: isGuest }"
            >
              退会する
            </a>
          </div>
        </form>
        <v-sidebar-right></v-sidebar-right>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import axios from "axios";
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      isGuest: false,
      user: undefined,
      file: undefined,
      errors: "",
      message: ""
    };
  },
  created() {
    this.setUserData();
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
    has_user_image() {
      return !!this.user && this.user.user_image !== "/user_images/default.jpg";
    },
    user_image_with_number() {
      return this.user.user_image + '?' + Math.random();
    }
  },
  methods: {
    ...mapActions({
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    setUserData() {
      axios.get("/api/current_user").then((res) => {
        this.user = res.data;
      });
    },
    async cancelEmailConfirmation() {
      await axios.delete(`/api/email_confirmations/${this.user.id}`).then((res) => {
        this.flashMessage.success({
          title: res.data.message,
          time: 0,
          icon: '/flash/success.svg',
        });
      });
      await axios.get("/api/current_user").then((res) => {
        this.setCurrentUserAction(res.data);
        this.setUserData();
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
      this.errors = '';
      let formData = new FormData();
      formData.append("user[username]", this.user.username);
      formData.append("user[email]", this.user.email);
      if (this.user.remove_user_image === "1") {
        formData.append("user[remove_user_image]", this.user.remove_user_image);
      }
      if (this.file != undefined) {
        formData.append("user[user_image]", this.file);
      }

      axios
        .put(`/api/users/${this.user.id}`, formData, {
          headers: {
            "Content-Type": "application/json"
          }
        })
        .then((res) => {
          this.$refs.file.value = null;
          this.setCurrentUserAction(res.data);
          this.setUserData();
          this.flashMessage.success({
            title: res.data.message,
            time: 0,
            icon: '/flash/success.svg',
          });
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },
    cancelOauth(provider) {
      axios.delete("/cancel_oauth/" + provider).then((res) => {
        this.flashMessage.success({
          title: res.data.message,
          time: 0,
          icon: '/flash/success.svg',
        });
        this.setCurrentUserAction(res.data);
        this.setUserData();
      });
    },
    accountCancel() {
      axios.delete(`/api/users/${this.getCurrentUser.id}`).then((res) => {
        this.$router.push({ name: "login" });
        this.flashMessage.success({
          title: res.data.message,
          time: 0,
          icon: '/flash/success.svg',
        });
      });
    }
  }
};
</script>

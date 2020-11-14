<template>
  <div>
    <div class="container inner">
      <sidebar-left></sidebar-left>
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
          </div>
          <div class="form__group">
            <label class="form__label">メールアドレス</label>
            <input type="email" v-model="user.email" class="form__input" />
            <p class="form__desc">
              アドレスを変更すると、確認のため新しいアドレスにメールを送信します。<strong
                >新しいアドレスは確認が完了するまで有効化されません。</strong
              >
            </p>
            <div v-if="unconfirmed_email" class="form__notice">
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
                :src="this.getCurrentUser.user_image"
                :alt="this.getCurrentUser.username + 'のプロフィール画像'"
                class="profile-img"
              />
              <input type="file" ref="file" @change="onImageUpload" />
            </div>
            <div v-if="has_user_image" class="form__profile-default">
              <input
                type="checkbox"
                v-model="user.remove_user_image"
                id="remove_user_image"
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
                  <a
                    v-if="user.facebook_uid && !user.auto_generated_password"
                    @click="cancelOauth(facebook)"
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
                  <a
                    v-if="user.twitter_uid && !user.auto_generated_password"
                    @click="cancelOauth(twitter)"
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
                  <a
                    v-if="user.google_uid && !user.auto_generated_password"
                    @click="cancelOauth(google)"
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
            <div @click="submit()" class="btn-main btn--md">変更する</div>
            <div
              @click="accountCancel()"
              class="form__cancel"
              :class="{ disable_for_guest: isGuest }"
            >
              退会する
            </div>
          </div>
        </form>
        <sidebar-right></sidebar-right>
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
      file: undefined
    };
  },
  created() {
    this.setUserData();
  },
  computed: {
    ...mapGetters(["getCurrentUser"]),
    unconfirmed_email() {
      this.setUserData();
      return this.user.unconfirmed_email;
    },
    has_user_image() {
      return this.user.user_image !== "/user_images/default.jpg";
    }
  },
  methods: {
    ...mapActions(["currentUserAction"]),
    setUserData() {
      this.user = Vue.util.extend({}, this.getCurrentUser);
    },
    async cancelEmailConfirmation() {
      await axios.delete(`/api/email_confirmations/${this.user.id}`);
      await axios.get("/api/current_user").then((res) => {
        this.currentUserAction(res.data);
      });
    },
    submit() {
      // const config = {
      //   headers: {
      //     "Content-Type": "multipart/form-data"
      //   }
      // };
      let user_params = this.user;
      // user_params.user_image = this.file;

      // console.log(user_params);

      axios
        .put(`/api/users/${this.user.id}`, { user: user_params })
        .then((res) => {
          this.currentUserAction(res.data);
          this.user = {};
          this.uploadedImage = {};
        });

      // let user_params = this.user;
      // user_params.user_image = this.file;
      // console.log(user_params.user_image);
      // axios
      //   .put(`/api/users/${this.user.id}`, { user: user_params })
      //   .then((res) => {
      //     this.currentUserAction(res.data);
      //     this.user = {};
      //     this.uploadedImage = {};
      //   });
    },
    onImageUpload: function (e) {
      this.file = this.$refs.file.files[0];
    },
    cancelOauth() {},
    accountCancel() {}
  }
};
</script>

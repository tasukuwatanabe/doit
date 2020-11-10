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
        <form action="" class="form user-form">
          <div class="form__group"></div>
          <div class="form__group">
            <div class="form__notice"></div>
          </div>
          <div class="form__group"></div>
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
                <td></td>
              </tr>
              <tr>
                <td>Twitter</td>
                <td>
                  <div class="sns-icon sns-icon--twitter">
                    <i class="fab fa-twitter"></i>
                  </div>
                </td>
                <td></td>
              </tr>
              <tr>
                <td>Google</td>
                <td>
                  <div class="sns-icon sns-icon--google">
                    <i class="fab fa-google"></i>
                  </div>
                </td>
                <td></td>
              </tr>
            </table>
          </div>
          <div class="form__action"></div>
        </form>
        <sidebar-right></sidebar-right>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  props: ["userId"],
  data() {
    return {
      currentUser: []
    };
  },
  mounted() {
    axios
      .get("/api/current_user.json")
      .then((response) => (this.currentUser = response.data));
  }
};
</script>

<style scoped>
.error-list {
  list-style-type: none;
  font-size: 12px;
  padding-left: 0;
  margin-top: 5px;
  margin-bottom: 10px;
}
</style>

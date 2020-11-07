<template>
  <div>
    <div class="container inner">
      <sidebar-left></sidebar-left>
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
          <div class="form__group"></div>
          <div class="form__group"></div>

          <div class="form__action">
            <div class="btn-main btn--md">パスワードを更新する</div>
          </div>
        </form>
      </div>
      <sidebar-right></sidebar-right>
    </div>
  </div>
</template>

<script>
import SidebarLeft from "./sidebar_left.vue";
import SidebarRight from "./sidebar_right.vue";

export default {
  components: {
    "sidebar-left": SidebarLeft,
    "sidebar-right": SidebarRight
  },
  props: ["userId"],
  data() {
    return {};
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

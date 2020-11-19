<template></template>

<script>
import { mapGetters } from "vuex";

export default {
  created() {
    this.showFlash();
  },
  methods: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
    showFlash() {
      if (this.$route.query.email_confirmed === 'true') {
        this.flashMessage.success({
          title: "メールアドレスが更新されました",
          icon: '/flash/success.svg',
        });
      } else if (this.$route.query.email_confirmed === 'false') {
        this.flashMessage.error({
          title: "リンクが有効ではありません",
          icon: '/flash/error.svg',
        });
      } else if (this.$route.query.account_activation === 'already') {
        this.flashMessage.info({
          title: "アカウントはすでに有効です",
          icon: '/flash/info.svg',
        });
      } else if (this.$route.query.account_activation === 'done') {
        this.flashMessage.success({
          title: "アカウントが有効化されました",
          icon: '/flash/success.svg',
        });
      } else if (this.$route.query.account_activation === 'invalid') {
        this.flashMessage.error({
          title: "有効化リンクが無効です",
          icon: '/flash/error.svg',
        });
      } else if (this.$route.query.oauth === 'success') {
        this.flashMessage.success({
          title: this.$route.query.provider + "でログインしました",
          icon: '/flash/success.svg',
        });
      }

      this.$router.push({ name: 'todos' });
    }
  }
}
</script>
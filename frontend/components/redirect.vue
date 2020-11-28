<template></template>

<script>
export default {
  created() {
    this.showFlash();
  },
  methods: {
    showFlash() {
      if (this.$route.query.email_confirmed === 'true') {
        this.flashMessage.success({
          title: "メールアドレスが更新されました",
          time: 5000,
          icon: 'assets/images/icons/success.svg',
        });
      } else if (this.$route.query.email_confirmed === 'false') {
        this.flashMessage.error({
          title: "リンクが有効ではありません",
          time: 5000,
          icon: 'assets/images/icons/error.svg',
        });
      } else if (this.$route.query.account_activation === 'already') {
        this.flashMessage.info({
          title: "アカウントはすでに有効です",
          time: 5000,
          icon: 'assets/images/icons/info.svg',
        });
      } else if (this.$route.query.account_activation === 'done') {
        this.flashMessage.success({
          title: "アカウントが有効化されました",
          time: 5000,
          icon: 'assets/images/icons/success.svg',
        });
      } else if (this.$route.query.account_activation === 'invalid') {
        this.flashMessage.error({
          title: "有効化リンクが無効です",
          time: 5000,
          icon: 'assets/images/icons/error.svg',
        });
      } else if (this.$route.query.oauth === 'success') {
        this.flashMessage.success({
          title: this.$route.query.provider + "でログインしました",
          time: 5000,
          icon: 'assets/images/icons/success.svg',
        });
      }

      this.$router.push({ name: 'todos' });
    }
  }
}
</script>
<template></template>

<script>
import { mapActions } from 'vuex';
import Data from "./mixins/data";
import Flash from "./mixins/flash";

export default {
  mixins: [Flash, Data],
  mounted() {
    this.showFlash();
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction",
      setCurrentUserAction: 'user/setCurrentUserAction'
    }),
    showFlash() {
      if (this.$route.query.email_confirmed === 'true') {
        const message = "メールアドレスが更新されました。再度ログインしてください"
        this.generateFlash('success', message);
      } else if (this.$route.query.email_confirmed === 'false') {
        const message = "リンクが有効ではありません"
        this.generateFlash('error', message);
      } else if (this.$route.query.email_confirmed === 'expired') {
        const message = "リンクの有効期限が過ぎています"
        this.generateFlash('error', message);
      } else if (this.$route.query.account_activation === 'already') {
        const message = "アカウントはすでに有効です"
        this.generateFlash('info', message);
      } else if (this.$route.query.account_activation === 'activated') {
        const message = "アカウントが有効化されました"
        this.generateFlash('success', message);
      } else if (this.$route.query.account_activation === 'invalid') {
        const message = "有効化リンクが無効です"
        this.generateFlash('error', message);
      }

      this.$router.push({ name: 'todos' });
    }
  }
}
</script>

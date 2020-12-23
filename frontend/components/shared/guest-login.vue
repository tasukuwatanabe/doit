<template>
  <div>
    お試しの方は
    <a @click="guestLogin" class="form__link--default">
      ゲストログイン
    </a>
  </div>
</template>

<script>
import axiosForBackend from 'axios';
import { mapActions } from 'vuex';
import Flash from "../mixins/flash";

export default {
  mixins: [Flash],
  methods: {
    ...mapActions({
      setCurrentUserAction: 'user/setCurrentUserAction',
    }),
    guestLogin() {
      const session_params = {
        email: 'guest@example.com',
      };
      axiosForBackend
        .post('/login', { session: session_params })
        .then((res) => {
          this.setCurrentUserAction(res.data);
          this.$router.push({ name: 'todos' });
          const message = "ゲストユーザーでログインしました。"
          this.generateFlash('success', message);
        })
        .catch((error) => {
          this.generateFlash('error', error.message);
        });
    },
  },
};
</script>
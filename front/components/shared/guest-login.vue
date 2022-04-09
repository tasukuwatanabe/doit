<template>
  <div>
    お試しの方は
    <a @click="guestLogin" class="form__link--default">
      ゲストログイン
    </a>
  </div>
</template>

<script>
import { axiosForBackend } from '../../config/axios';
import { mapActions } from 'vuex';
import Data from "../mixins/data";
import Flash from "../mixins/flash";

export default {
  mixins: [Flash, Data],
  methods: {
    ...mapActions({
      setCurrentUserAction: 'user/setCurrentUserAction'
    }),
    guestLogin() {
      const guest_email = {
        email: 'guest@example.com',
      };
      axiosForBackend
        .post('/guest', { session: guest_email })
        .then((res) => {
          this.setCurrentUserAction(res.data.user);
          this.$router.push({ name: 'todos' });
          this.fetchData();
          this.generateFlash('success', res.data.message);
        })
        .catch((error) => {
          const message = "ゲストログインに失敗しました"
          this.generateFlash('error', message);
        });
    },
  },
};
</script>
import axiosForBackend from 'axios';
import { mapActions } from 'vuex';
import Flash from './flash';

export default {
  mixins: [Flash],
  methods: {
    ...mapActions({
      logoutAction: 'user/logoutAction',
    }),
    forceLogout(error) {
      if (error.response && error.response.status === 500) {
        axiosForBackend.delete('/logout').then(() => {
          this.logoutAction();
          this.$router.push({ name: 'login' });
          const message = '再度ログインしてください';
          this.generateFlash('error', message);
        });
      }
    },
  },
};

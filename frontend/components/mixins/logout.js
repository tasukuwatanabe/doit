import axios from 'axios';
import { mapActions } from 'vuex';

export default {
  methods: {
    ...mapActions({
      logoutAction: 'user/logoutAction',
    }),
    forceLogout(error) {
      if (error.response && error.response.status === 500) {
        axios.delete('/logout').then(() => {
          this.logoutAction();
          this.$router.push({ name: 'login' });
          this.flashMessage.error({
            title: '再度ログインしてください',
            time: 5000,
            icon: '/icons/error.svg',
          });
        });
      }
    },
  },
};

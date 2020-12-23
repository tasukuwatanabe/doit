import axios from 'axios';
import { mapActions } from 'vuex';

export default {
  methods: {
    ...mapActions({
      logoutAction: 'user/logoutAction',
      addLoadingCountAction: 'loading/addLoadingCountAction',
      subtractLoadingCountAction: 'loading/subtractLoadingCountAction',
    }),
    forceLogout(error) {
      if (error.response && error.response.status === 500) {
        this.addLoadingCountAction();
        axios.delete('/logout').then(() => {
          this.logoutAction();
          this.$router.push({ name: 'login' });
          this.flashMessage.error({
            title: '再度ログインしてください',
            time: 5000,
            icon: '/icons/error.svg',
          });
        });
        this.subtractLoadingCountAction();
      }
    },
  },
};

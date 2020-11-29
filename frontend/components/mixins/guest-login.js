import axios from 'axios';
import { mapActions } from 'vuex';

export default {
  methods: {
    ...mapActions({
      setCurrentUserAction: 'user/setCurrentUserAction',
    }),
    guestLogin() {
      axios
        .post('/api/guest_login')
        .then((res) => {
          this.setCurrentUserAction(res.data.user);
          this.$router.push({ name: 'todos' });
          this.flashMessage.success({
            title: res.data.message,
            time: 5000,
            icon: 'assets/images/icons/success.svg',
          });
        })
        .catch((error) => {
          this.flashMessage.error({
            title: error.message,
            time: 5000,
            icon: 'assets/images/icons/error.svg',
          });
        });
    },
  },
};

import axios from "axios";
import { mapActions } from "vuex";

export default {
  methods: {
    ...mapActions({
      setCurrentUserAction: 'user/setCurrentUserAction'
    }),
    async guestLogin() {
      await axios.post("/api/guest_login")
        .then((res) => {
          console.log("todosにリダイレクトします");
          this.$router.push({ name: "todos" });
          this.flashMessage.success({
            title: res.data.message,
            time: 5000,
            icon: '/flash/success.svg',
          });
        })
        .catch((error) => {
          this.flashMessage.error({
            title: error.response.data.message,
            icon: '/flash/error.svg',
          })
        });
      await axios.get("/api/current_user").then((res) => {
        this.setCurrentUserAction(res.data);
      });
    }
  }
}
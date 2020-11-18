import axios from "axios";

export default {
  methods: {
    guestLogin() {
      axios.post("/api/guest_login")
        .then((res) => {
          this.$router.push({ name: "todos" });
          this.flashMessage.success({
            title: res.data.message,
            icon: '/flash/success.svg',
          })
        })
        .catch((error) => {
          this.flashMessage.error({
            title: error.response.data.message,
            icon: '/flash/error.svg',
          })
        });
    }
  }
}
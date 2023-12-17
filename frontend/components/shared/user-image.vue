<template>
  <img class="profile-img"
    :alt="this.getCurrentUser.username + ' アイコン'"
    :src="userImageWithNumber"
  />
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "UserImage",
  props: ['userImage'],
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
    userImageWithNumber() {
      if (this.userImage) {
        return this.userImage.url + '?' + Math.random();
      } else {
        return 'http://localhost:3000/user_icons/default.jpg';
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.profile-img {
  border-radius: 50%;
}
</style>

<template>
  <img class="profile-img"
    :alt="this.getCurrentUser.username + ' アイコン'"
    :src="userImageWithRandomNumber"
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
    userImageWithRandomNumber() {
      if (this.userImage) {
        return this.userImage.url + '?' + Math.random();
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
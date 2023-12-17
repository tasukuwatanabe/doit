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
      const hostPath = process.env.NODE_ENV === 'production'
                                              ? 'https://api.doit-plan.com'
                                              : 'http://localhost:3000';
      if (this.userImage) {
        return this.userImage.url + '?' + Math.random();
      } else {
        return `${hostPath}/user_icons/default.jpg`;
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

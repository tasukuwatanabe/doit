<template>
  <div class="modal" v-if="modalActive">
    <div class="modal__layer">
      <div class="modal__box">
        <div class="fa-case" @click="toggleModal">
          <i class="fas fa-times"></i>
        </div>
        <div class="modal__confirm-text">
          データが削除されます<br>退会してもよろしいですか？
        </div>
        <div class="btn-case">
          <div @click="toggleModal" class="btn btn--gray btn--sm">
            キャンセル
          </div>
          <div @click="accountCancel" class="btn btn--red btn--sm">
            退会する
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axiosForBackend from "../../config/axios";
import { mapGetters, mapActions } from "vuex";
import Modal from "../mixins/modal";
import Flash from "../mixins/flash";

export default {
  mixins: [Modal, Flash],
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
    }),
  },
  methods: {
    ...mapActions({
      setCurrentUserAction: "user/setCurrentUserAction"
    }),
    accountCancel() {
      axiosForBackend
        .delete(`/users/${this.getCurrentUser.id}`)
        .then((res) => {
          this.setCurrentUserAction("");
          this.$router.push({ name: "login" });
          this.generateFlash('success', res.data.message);
      });
    },
    toggleModalStatus() {
      this.toggleModal();
    }
  }
};
</script>

<style lang="scss" scoped>
.modal {
  &__box {
    max-width: 400px;
    padding: 55px 30px 40px;

    .fa-case {
      top: 15px;
      right: 20px;
    }
  }
  &__confirm-text {
    line-height: 2;
    font-size: 1.1em;
    text-align: center;
  }
}
</style>
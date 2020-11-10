<template>
  <div class="modal" :class="{ 'is-open': isModalActive }">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent novalidate="true" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="closeModal">
              <i class="fas fa-times"></i>
            </div>
            <div class="form__group row">
              <div class="col-3 form__label">タイトル</div>
              <div class="col-9">
                <input type="text" class="form__input" required />
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3 form__label">ラベル</div>
              <div class="col-9">
                <select class="form__select">
                  <option>ラベルを選択</option>
                  <option
                    v-for="label in labels"
                    :key="label.id"
                    :value="label.id"
                  ></option>
                </select>
              </div>
            </div>
            <div class="btn-case">
              <div @click="closeModal" class="btn-gray btn--sm">キャンセル</div>
              <div @click="updateShortcut(shortcut)" class="btn-main btn--sm">
                更新する
              </div>
              <!-- <div @click="createShortcut()" class="btn-main btn--sm" v-else>
                新規作成
              </div> -->
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  name: "ShortcutModal",
  data() {
    return {
      labels: []
    };
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    createShortcut(shortcut) {
      axios
        .post("/api/shortcuts/", {
          shortcut: this.shortcut
        })
        .then((res) => {
          this.shortcut = {};
          this.fetchShortcuts();
          this.closeModal();
        });
    },
    updateShortcut(shortcut) {
      axios
        .put(`/api/shortcuts/${shortcut.id}`, { shortcut: this.editedShortcut })
        .then((res) => {
          this.fetchShortcuts();
          this.closeModal();
        });
    }
  }
};
</script>

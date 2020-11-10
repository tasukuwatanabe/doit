<template>
  <div class="modal" :class="{ 'is-open': modalActive }">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent novalidate="true" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal">
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
              <div @click="toggleModal" class="btn-gray btn--sm">
                キャンセル
              </div>
              <div @click="submitShortcut(shortcut)" class="btn-main btn--sm">
                {{ btnText }}
              </div>
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
      labels: [],
      btnText: ""
    };
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    setShortcutValue(shortcut) {
      this.modalActive = true;
      if (shortcut) {
        this.shortcut.title = shortcut.title;
        this.shortcut.label_id = shortcut.label_id;
      }
      this.btnText = shortcut ? "更新する" : "新規作成";
    },
    async shortcutSubmit(shortcut) {
      if (shortcut) {
        await axios.put(`/api/shortcuts/${this.shortcut.id}`, {
          params: { shortcut: this.shortcut }
        });
      } else {
        await axios.post("/api/shortcuts", {
          params: { shortcut: this.shortcut }
        });
      }
      this.shortcut = {};
      this.modalActive = false;
      this.$emit("fetch-shortcuts");
    }
  }
};
</script>

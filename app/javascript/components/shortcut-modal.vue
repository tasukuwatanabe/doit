<template>
  <div class="modal" :class="{ 'is-open': modalActive }">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent novalidate="true" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal()">
              <i class="fas fa-times"></i>
            </div>
            <div class="form__group row">
              <div class="col-3 form__label">タイトル</div>
              <div class="col-9">
                <input
                  type="text"
                  v-model="shortcut.title"
                  class="form__input"
                  required
                />
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3 form__label">ラベル</div>
              <div class="col-9">
                <select class="form__select" v-model="shortcut.label_id">
                  <option>ラベルを選択</option>
                  <option
                    v-for="label in labels"
                    :key="label.id"
                    :value="label.id"
                  >
                    {{ label.title }}
                  </option>
                </select>
              </div>
            </div>
            <div class="btn-case">
              <div @click="toggleModal()" class="btn-gray btn--sm">
                キャンセル
              </div>
              <div @click="shortcutSubmit()" class="btn-main btn--sm">
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
import axios from "axios";
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  name: "ShortcutModal",
  data() {
    return {
      shortcut: {
        id: undefined,
        title: undefined,
        label_id: undefined
      },
      shortcuts: [],
      labels: [],
      btnText: ""
    };
  },
  created() {
    this.fetchLabels();
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    fetchLabels() {
      axios.get("/api/shortcuts").then((res) => {
        this.labels = res.data.labels;
      });
    },
    setShortcutValue(val) {
      this.toggleModal();
      const hasValue = function () {
        return val != undefined;
      };
      this.shortcut.id = hasValue() ? val.id : undefined;
      this.shortcut.title = hasValue() ? val.title : undefined;
      this.shortcut.label_id = hasValue() ? val.label_id : undefined;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    async shortcutSubmit() {
      const shortcut_id = this.shortcut.id;
      const shortcut_params = {
        title: this.shortcut.title,
        label_id: this.shortcut.label_id
      };
      if (shortcut_id) {
        await axios
          .put(`/api/shortcuts/${shortcut_id}`, {
            shortcut: shortcut_params
          })
          .catch((error) => {
            console.log(error);
          });
      } else {
        await axios.post("/api/shortcuts", {
          shortcut: shortcut_params
        });
      }
      this.shortcut = {};
      this.toggleModal();
      this.$emit("fetch-shortcuts");
    }
  }
};
</script>

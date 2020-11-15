<template>
  <div class="modal" v-if="modalActive">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent novalidate="true" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal()">
              <i class="fas fa-times"></i>
            </div>
            <div v-if="!!custom_error" class="error">
              <span class="error__icon">
                <i class="fas fa-exclamation-triangle"></i>
              </span>
              <p class="error__text">{{ custom_error }}</p>
              <div class="btn-case">
                <div @click="toggleModal()" class="btn-gray btn--sm error__btn">
                  閉じる
                </div>
              </div>
            </div>
            <div v-else>
              <div class="form__group row">
                <div class="col-3">
                  <div
                    class="form__label"
                    :class="{ 'form__label--with-error': !!errors.title }"
                  >
                    タイトル<span class="form__label--required">*</span>
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="text"
                    v-model="shortcut.title"
                    class="form__input"
                    required
                  />
                  <span class="form__error" v-if="!!errors.title">
                    {{ errors.title[0] }}
                  </span>
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
      btnText: "",
      custom_error: ""
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
      this.custom_error = "";
      this.toggleModal();
      const hasValue = function () {
        return val != undefined;
      };
      this.shortcut.id = hasValue() ? val.id : undefined;
      this.shortcut.title = hasValue() ? val.title : undefined;
      this.shortcut.label_id = hasValue() ? val.label_id : undefined;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    setError(error) {
      this.custom_error = error;
      this.toggleModal();
    },
    shortcutSubmit() {
      const shortcut_id = this.shortcut.id;
      const shortcut_params = {
        title: this.shortcut.title,
        label_id: this.shortcut.label_id
      };
      if (shortcut_id) {
        axios
          .put(`/api/shortcuts/${shortcut_id}`, {
            shortcut: shortcut_params
          })
          .then(() => {
            this.shortcut = {};
            this.toggleModal();
            this.$emit("fetch-shortcuts");
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      } else {
        axios
          .post("/api/shortcuts", {
            shortcut: shortcut_params
          })
          .then(() => {
            this.shortcut = {};
            this.toggleModal();
            this.$emit("fetch-shortcuts");
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      }
    }
  }
};
</script>

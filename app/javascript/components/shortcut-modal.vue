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
                    v-model="shortcut_title"
                    class="form__input"
                    required
                  />
                  <span class="form__error" v-if="!!errors.title">
                    {{ errors.title }}
                  </span>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3 form__label">ラベル</div>
                <div class="col-9">
                  <select class="form__select" v-model="label_id">
                    <option>ラベルを選択</option>
                    <option
                      v-for="label in labels"
                      :key="label.label_id"
                      :value="label.label_id"
                    >
                      {{ label.label_title }}
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
      shortcut_id: "",
      shortcut_title: "",
      label_id: [],
      labels: [],
      btnText: "",
      custom_error: "",
    };
  },
  created() {
    this.fetchLabels();
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    fetchLabels() {
      axios
        .get("/api/labels")
        .then((res) => {
          this.labels = res.data;
        })
        .catch(error => {
          console.log("通信がキャンセルされました");
        });;
    },
    setShortcutValue(val) {
      this.custom_error = "";
      this.toggleModal();
      const hasValue = function () {
        return val != undefined;
      };
      this.shortcut_id = hasValue() ? val.shortcut_id : undefined;
      this.shortcut_title = hasValue() ? val.shortcut_title : undefined;
      this.label_id = hasValue() ? val.label_id : undefined;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    setError(error) {
      this.custom_error = error;
      this.toggleModal();
    },
    shortcutSubmit() {
      if (this.shortcut_id) {
        axios
          .put(`/api/shortcuts/${this.shortcut_id}`, {
            shortcut: {
              title: this.shortcut_title,
              label_ids: [this.label_id]
            }
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
            shortcut: {
              title: this.shortcut_title,
              label_ids: [this.label_id]
            }
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

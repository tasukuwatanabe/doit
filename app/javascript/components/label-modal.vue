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
                    ref="inputLabelTitle"
                    type="text"
                    class="form__input"
                    v-model="label_title"
                    required
                  />
                  <span class="form__error" v-if="!!errors.title">
                    {{ errors.title }}
                  </span>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">ラベルの色</div>
                </div>
                <div class="col-9">
                  <div class="color-select" @click="toggleColorPicker()">
                    <div class="color-select__box">
                      <div
                        class="color-select__palette"
                        :style="{
                          backgroundColor: colorPicker.hex
                        }"
                      ></div>
                      {{ colorPicker.hex }}
                    </div>
                    <div class="color-select__picker">
                      <compact-picker
                        v-if="displayColorPicker"
                        v-model="colorPicker"
                      ></compact-picker>
                    </div>
                  </div>
                </div>
              </div>
              <div class="btn-case">
                <div @click="toggleModal()" class="btn-gray btn--sm">
                  キャンセル
                </div>
                <div @click="labelSubmit()" class="btn-main btn--sm">
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
import { Compact } from "vue-color";
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

const defaultColor = "#F44E3B";

export default {
  name: "LabelModal",
  data() {
    return {
      label_id: "",
      label_title: "",
      colorPicker: {
        hex: defaultColor
      },
      displayColorPicker: "",
      btnText: "",
      custom_error: "",
    };
  },
  components: {
    "compact-picker": Compact
  },
  mixins: [Modal, ColorOnRgb],
  computed: {
    labelColor() {
      return function (label) {
        return this.label_color;
      };
    }
  },
  methods: {
    setLabelValue(val) {
      this.custom_error = "";
      this.toggleModal();
      const hasValue = () => {
        return val != undefined;
      };
      this.label_id = hasValue() ? val.label_id : undefined;
      this.label_title = hasValue() ? val.label_title : undefined;
      this.colorPicker.hex = hasValue() ? val.label_color : defaultColor;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    setError(error) {
      this.custom_error = error;
      this.toggleModal();
    },
    labelSubmit() {
      const label_params = {
        title: this.label_title,
        color: this.colorPicker.hex
      };
      if (this.label_id) {
        axios
          .put(`/api/labels/${this.label_id}`, { label: label_params })
          .then(() => {
            this.label = {};
            this.toggleModal();
            this.$emit("fetch-labels");
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      } else {
        axios
          .post("/api/labels", { label: label_params })
          .then(() => {
            this.label = {};
            this.toggleModal();
            this.$emit("fetch-labels");
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      }
    },
    toggleColorPicker() {
      this.displayColorPicker = !this.displayColorPicker;
    },
    toggleModal() {
      this.modalActive = !this.modalActive;
      this.displayColorPicker = false;
      this.colorPicker.hex = defaultColor;
    }
  }
};
</script>

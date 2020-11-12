<template>
  <div class="modal" v-if="modalActive">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent novalidate="true" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal()">
              <i class="fas fa-times"></i>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">タイトル</div>
              </div>
              <div class="col-9">
                <input
                  ref="inputLabelTitle"
                  type="text"
                  class="form__input"
                  v-model="label.title"
                  required
                />
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
      label: {
        id: undefined,
        title: undefined
      },
      colorPicker: {
        hex: defaultColor
      },
      displayColorPicker: false,
      btnText: undefined
    };
  },
  components: {
    "compact-picker": Compact
  },
  mixins: [Modal, ColorOnRgb],
  computed: {
    labelColor: function () {
      return function (label) {
        return this.label.color;
      };
    }
  },
  methods: {
    setLabelValue(val) {
      this.toggleModal();
      const hasValue = function () {
        return val != undefined;
      };
      this.label.id = hasValue() ? val.id : undefined;
      this.label.title = hasValue() ? val.title : undefined;
      this.colorPicker.hex = hasValue() ? val.color : defaultColor;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    async labelSubmit() {
      const label_id = this.label.id;
      const label_params = {
        title: this.label.title,
        color: this.colorPicker.hex
      };
      if (label_id) {
        await axios.put(`/api/labels/${label_id}`, { label: label_params });
      } else {
        await axios.post("/api/labels", { label: label_params });
      }
      this.label = {};
      this.toggleModal();
      this.$emit("fetch-labels");
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

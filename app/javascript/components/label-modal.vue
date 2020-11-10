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
              <div class="col-3">
                <div class="form__label">タイトル</div>
              </div>
              <div class="col-9">
                <input
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
                <div
                  class="color-select"
                  ref="colorDisplay"
                  @click="toggleColorPicker"
                >
                  <div class="color-select__box">
                    <div
                      class="color-select__palette"
                      :style="{
                        backgroundColor: colorPicker.hex
                      }"
                    ></div>
                    {{ colorPicker.hex }}
                  </div>
                  <div class="color-select__picker" ref="colorPicker">
                    <compact-picker
                      v-if="displayColorPicker"
                      v-model="colorPicker"
                    ></compact-picker>
                  </div>
                </div>
              </div>
            </div>
            <div class="btn-case">
              <div @click="closeModal" class="btn-gray btn--sm">キャンセル</div>
              <div @click="updateLabel" class="btn-main btn--sm">更新する</div>
              <!-- <div @click="createLabel" class="btn-main btn--sm" v-else>
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
import axios from "axios";
import { Compact } from "vue-color";
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

const defaultColor = "#F44E3B";

export default {
  name: "LabelModal",
  data() {
    return {
      label: {},
      colorPicker: {
        hex: defaultColor
      },
      displayColorPicker: false
    };
  },
  components: {
    "compact-picker": Compact
  },
  mixins: [Modal, ColorOnRgb],
  mounted() {
    window.addEventListener(
      "click",
      (this._onBlurHandler = (event) => {
        if (
          this.$refs.colorPicker.contains(event.target) ||
          this.$refs.colorDisplay.contains(event.target)
        ) {
          return;
        }
        this.displayColorPicker = false;
      })
    );
  },
  beforeDestroy() {
    window.removeEventListener("click", this._onBlurHandler);
  },
  methods: {
    createLabel(label) {
      this.label.color = this.colorPicker.hex;
      axios
        .post("/api/labels", {
          label: this.label
        })
        .then((res) => {
          this.label = {};
          this.fetchLabel();
          this.closeModal();
        });
    },
    updateLabel() {
      this.label.color = this.colorPicker.hex;
      axios
        .put(`/api/labels/${this.label.id}`, { label: this.label })
        .then((res) => {
          this.closeModal();
        });
    },
    toggleColorPicker() {
      this.displayColorPicker = !this.displayColorPicker;
    }
    // this.displatColorPicker = false;
    //   this.colorPicker.hex = defaultColor;
  }
};
</script>

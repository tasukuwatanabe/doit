<template>
  <div>
    <div class="container inner">
      <sidebar-left></sidebar-left>
      <div class="content">
        <div class="headline">
          <div class="headline__title">
            ラベルの管理
            <span class="icon headline__icon">
              <i class="fas fa-tag"></i>
            </span>
          </div>
          <p class="headline__text">
            ラベルを追加することでToDoを分類することができます。
          </p>
          <div class="page-action headline__page-action">
            <a @click="openModal" class="page-action__btn btn-outlined btn--sm">
              <span class="page-action__icon">
                <i class="fas fa-plus"></i>
              </span>
              <span class="page-action__text modal-trigger">新規追加</span>
            </a>
          </div>
        </div>
        <ul class="list" v-if="labels.length">
          <li class="list__item" v-for="label in labels" :key="label.id">
            <div class="list__block list__block--left">
              <div
                class="label label--margin"
                :style="{
                  color: colorOnRgb(label.color),
                  backgroundColor: label.color
                }"
              >
                {{ label.title }}
              </div>
            </div>
            <div class="list__block list__block--right">
              <div class="label-in-use">
                {{ labelTodosCount(label) }}個のToDoで使用中
              </div>
              <div class="item-action">
                <a @click="editLabel(label)" class="item-action__btn">
                  <i class="fas fa-pencil-alt"></i>
                </a>
                <a @click="deleteLabel(label.id)" class="item-action__btn">
                  <i class="fas fa-trash"></i>
                </a>
              </div>
            </div>
          </li>
        </ul>
        <div class="no-result no-result" v-else>
          <div class="no-result__illustration">
            <img src="/illustrations/il-mindmap.png" alt="目標達成のイラスト" />
          </div>
        </div>
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
                        v-if="label"
                        v-model.lazy="label.title"
                        required
                      />
                      <div v-if="errors.length">{{ errors[0] }}</div>
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
                      <div v-if="errors.length">{{ errors[0] }}</div>
                    </div>
                  </div>
                  <div class="btn-case">
                    <div @click="closeModal" class="btn-gray btn--sm">
                      キャンセル
                    </div>
                    <div
                      @click="updateLabel"
                      class="btn-main btn--sm"
                      v-if="isEditing"
                    >
                      更新する
                    </div>
                    <div @click="createLabel" class="btn-main btn--sm" v-else>
                      新規作成
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
          <sidebar-right></sidebar-right>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import axios from "axios";
import SidebarLeft from "./sidebar_left.vue";
import SidebarRight from "./sidebar_right.vue";
import { Compact } from "vue-color";

var defaultColor = "#F44E3B";

export default {
  name: "Label",
  components: {
    "sidebar-left": SidebarLeft,
    "sidebar-right": SidebarRight,
    "compact-picker": Compact
  },
  data() {
    return {
      isModalActive: false,
      labels: [],
      todos: [],
      label: {},
      errors: [],
      isEditing: false,
      colorPicker: {
        hex: defaultColor
      },
      displayColorPicker: false
    };
  },
  created() {
    this.fetchLabel();
  },
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
    toggleColorPicker() {
      this.displayColorPicker = !this.displayColorPicker;
    },
    fetchLabel() {
      axios.get("/api/labels").then((res) => {
        this.labels = res.data.labels;
        this.todos = res.data.todos;
      });
    },
    labelTodosCount(label) {
      if (this.todos.length) {
        return this.todos.filter((todo) => todo.label_id === label.id).length;
      } else {
        return 0;
      }
    },
    colorOnRgb(hex) {
      if (hex.slice(0, 1) == "#") hex = hex.slice(1);
      if (hex.length == 3)
        hex =
          hex.slice(0, 1) +
          hex.slice(0, 1) +
          hex.slice(1, 2) +
          hex.slice(1, 2) +
          hex.slice(2, 3) +
          hex.slice(2, 3);

      var rgb = [hex.slice(0, 2), hex.slice(2, 4), hex.slice(4, 6)].map(
        function (labeltr) {
          return parseInt(labeltr, 16);
        }
      );

      var red = rgb[0],
        green = rgb[1],
        blue = rgb[2];

      if (red * 0.299 + green * 0.587 + blue * 0.114 < 186) {
        return "white";
      }
    },
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
    editLabel(label) {
      this.label = label;
      this.colorPicker.hex = this.label.color;
      this.isEditing = true;
      this.openModal();
    },
    updateLabel() {
      this.label.color = this.colorPicker.hex;
      axios
        .put(`/api/labels/${this.label.id}`, { label: this.label })
        .then((res) => {
          this.closeModal();
        });
    },
    deleteLabel(id) {
      axios.delete(`/api/labels/${id}`).then((res) => {
        this.fetchLabel();
      });
    },
    openModal() {
      this.isModalActive = true;
    },
    closeModal() {
      this.fetchLabel();
      this.isModalActive = false;
      this.displatColorPicker = false;
      this.isEditing = false;
      this.label = {};
      this.colorPicker.hex = defaultColor;
      this.errors = [];
    }
  }
};
</script>

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
        <label-modal></label-modal>
      </div>
      <sidebar-right></sidebar-right>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import LabelModal from "./label-modal.vue";
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  name: "Label",
  components: {
    "label-modal": LabelModal
  },
  data() {
    return {
      labels: [],
      todos: [],
      label: {}
    };
  },
  created() {
    this.fetchLabel();
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
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
    editLabel(label) {
      this.label = label;
      this.colorPicker.hex = this.label.color;
      this.isEditing = true;
      this.openModal();
    },
    deleteLabel(id) {
      axios.delete(`/api/labels/${id}`).then((res) => {
        this.fetchLabel();
      });
    },
    resetLabel() {
      this.fetchLabel();
      this.label = {};
    }
  }
};
</script>

<template>
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
              backgroundColor: '#' + label.color
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
            <a @click="modalEditLabel(label)" class="item-action__btn">
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
      <div class="modal__layer" @click.self="closeModal">
        <div class="modal__box">
          <form @submit.prevent novalidate="true" class="form">
            <div class="modal-form">
              <div class="fa-case" @click="closeModal">
                <i class="fas fa-times"></i>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    タイトル
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="text"
                    class="form__input"
                    v-if="modalEditingLabel"
                    v-model="modalEditingLabel.title"
                    required
                  />
                  <input
                    type="text"
                    class="form__input"
                    v-else
                    v-model="label.title"
                    required
                  />
                  <div v-if="errors.length">{{ errors[0] }}</div>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    ラベルの色
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="text"
                    class="form__input"
                    v-if="modalEditingLabel"
                    v-model="modalEditingLabel.color"
                    required
                  />
                  <input
                    type="text"
                    class="form__input"
                    v-else
                    v-model="label.color"
                    required
                  />
                  <div v-if="errors.length">{{ errors[0] }}</div>
                </div>
              </div>
              <div class="btn-case">
                <div @click="closeModal" class="btn-gray btn--sm">
                  キャンセル
                </div>
                <div
                  @click="updateLabel(modalEditingLabel)"
                  class="btn-main btn--sm"
                  v-if="modalEditingLabel"
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
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      isModalActive: false,
      todos: [],
      labels: [],
      label: {
        title: "",
        color: ""
      },
      errors: [],
      editingLabelId: null,
      editedLabel: null,
      modalEditingLabel: null
    };
  },
  mounted() {
    this.fetchLabels();
  },
  methods: {
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
        function(labeltr) {
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
    fetchLabels() {
      this.errors = [];
      this.editedLabel = null;
      this.editingLabelId = null;
      axios.get("/api/labels.json").then(
        (response) => {
          this.labels = response.data[0].labels;
          this.todos = response.data[0].todos;
        },
        (error) => {
          console.log(error);
        }
      );
      axios.get("/api/todos.json").then(
        (response) => {
          this.todos = response.data;
        },
        (error) => {
          console.log(error);
        }
      );
    },
    setLabelTitle(id) {
      axios.get("/api/labels.json").then(
        (res) => {
          for (let i = 0; i < res.data.labels.length; i++) {
            this.labels.push(res.data.labels[i]);
          }
        },
        (error) => {
          console.log(error);
        }
      );
    },
    createLabel(label) {
      this.errors = [];
      if (!this.label.title) {
        this.errors.push("タイトルは必須です");
        return;
      }
      axios
        .post("/api/labels", {
          label: this.label
        })
        .then(
          (res) => {
            this.label.title = "";
            this.label.color = "";
            this.fetchLabels();
            this.closeModal();
          },
          (error) => {
            this.errors.push("エラー発生");
          }
        );
    },
    editLabel(label) {
      this.fetchLabels();
      this.editingLabelId = label.id;
    },
    modalEditLabel(label) {
      this.modalEditingLabel = label;
      this.openModal();
      this.fetchLabels();
    },
    updateLabel(label) {
      this.errors = [];
      if (!label.title || !label.color) {
        return;
      }
      this.closeModal();
      this.editedLabel = label;
      axios.put(`/api/labels/${label.id}`, { label: this.editedLabel }).then(
        (res) => {
          this.modalEditingLabel = null;
          this.fetchLabels();
        },
        (error) => {
          this.errors.push("エラーがあります");
        }
      );
    },
    deleteLabel(id) {
      axios.delete(`/api/labels/${id}`).then((res) => {
        this.fetchLabels();
      });
    },
    openModal() {
      this.isModalActive = true;
    },
    closeModal() {
      this.isModalActive = false;
      this.modalEditingLabel = null;
      this.errors = [];
    }
  }
};
</script>

<style scoped>
.error-list {
  list-style-type: none;
  font-size: 12px;
  padding-left: 0;
  margin-top: 5px;
  margin-bottom: 10px;
}
</style>

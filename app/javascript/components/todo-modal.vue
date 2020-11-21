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
                  class="form__input"
                  v-model="todo.title"
                  required
                />
                <span class="form__error" v-if="!!errors.title">
                  {{ errors.title }}
                </span>
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div
                  class="form__label"
                  :class="{ 'form__label--with-error': !!errors.todo_date }"
                >
                  日付<span class="form__label--required">*</span>
                </div>
              </div>
              <div class="col-9">
                <input
                  type="date"
                  v-model="todo.todo_date"
                  class="form__input"
                />
                <span class="form__error" v-if="!!errors.todo_date">
                  {{ errors.todo_date }}
                </span>
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">ラベル</div>
              </div>
              <div class="col-9">
                <select v-model="todo.label_id" class="form__select">
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
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">メモ</div>
              </div>
              <div class="col-9">
                <input type="text" class="form__input" v-model="todo.body" />
              </div>
            </div>
            <div class="btn-case">
              <div @click="toggleModal()" class="btn-gray btn--sm">
                キャンセル
              </div>
              <div @click="todoSubmit()" class="btn-main btn--sm">
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
import { mapGetters, mapActions } from "vuex";
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  data() {
    return {
      labels: [],
      todo: {
        id: undefined,
        title: undefined,
        label_id: undefined,
        todo_date: undefined,
        body: undefined
      },
      btnText: "",
    };
  },
  created() {
    this.fetchLabels();
  },
  computed: {
    ...mapGetters({
      getSelectedDate: "date/getSelectedDate",
      formatDate: "date/getFormatDate"
    })
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction"
    }),
    fetchLabels() {
      axios
        .get("/api/labels")
        .then((res) => {
          this.labels = res.data.labels;
        })
        .catch(error => {
          console.log("通信がキャンセルされました");
        });
    },
    setTodoValue(val) {
      this.toggleModal();
      const hasValue = function () {
        return val != undefined;
      };
      this.todo.id = hasValue() ? val.id : undefined;
      this.todo.title = hasValue() ? val.title : undefined;
      this.todo.label_id = hasValue() ? val.label_id : undefined;
      this.todo.body = hasValue() ? val.body : undefined;
      this.todo.todo_date = hasValue() ? val.todo_date : this.formatDate;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    todoSubmit() {
      const todo_id = this.todo.id;
      const todo_params = {
        title: this.todo.title,
        label_id: this.todo.label_id,
        todo_date: this.todo.todo_date,
        body: this.todo.body
      };
      if (todo_id) {
        axios
          .put(`/api/todos/${todo_id}`, { todo: todo_params })
          .then(() => {
            this.toggleModal();
            this.setSelectedDateAction(this.todo.todo_date);
            this.$emit("fetch-todos", this.todo.todo_date);
            this.todo = {};
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      } else {
        axios
          .post("/api/todos", { todo: todo_params })
          .then(() => {
            this.toggleModal();
            this.setSelectedDateAction(this.todo.todo_date);
            this.$emit("fetch-todos", this.todo.todo_date);
            this.todo = {};
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      }
    }
  }
};
</script>

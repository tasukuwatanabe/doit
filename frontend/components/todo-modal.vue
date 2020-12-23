<template>
  <div class="modal" v-if="modalActive">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent="todoSubmit" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal">
              <i class="fas fa-times"></i>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div
                  class="form__label"
                  :class="{ 'form__label--with-error': errors.title }"
                >
                  タイトル<span class="form__label--required">*</span>
                </div>
              </div>
              <div class="col-9">
                <input
                  type="text"
                  class="form__input"
                  v-model="todo.title"
                />
                <span class="form__error" v-if="errors.title">
                  {{ errors.title }}
                </span>
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div
                  class="form__label"
                  :class="{ 'form__label--with-error': errors.todo_date }"
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
                <span class="form__error" v-if="errors.todo_date">
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
                  <option :value="null">ラベルを選択</option>
                  <option
                    v-for="label in labels"
                    :key="label.id"
                    :value="label.id"
                  >
                    {{ label.label_title }}
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
              <div @click="toggleModal" class="btn btn--gray btn--sm">
                キャンセル
              </div>
              <button type="submit" class="btn btn--blue btn--sm">
                {{ btnText }}
              </button>
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
import Logout from "./mixins/logout";

export default {
  data() {
    return {
      labels: [],
      todo: {},
      btnText: "",
    };
  },
  mixins: [Modal, Logout],
  created() {
    this.fetchLabels();
  },
  computed: {
    ...mapGetters({
      getSelectedDate: "date/getSelectedDate"
    }),
    formattedDate() {
      let year = this.getSelectedDate.getFullYear();
      let month = this.getSelectedDate.getMonth() + 1;
      let date = this.getSelectedDate.getDate();

      month = ('0' + month).slice(-2)
      date = ('0' + date).slice(-2)

      return `${year}-${month}-${date}`;
    },
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction"
    }),
    fetchLabels() {
      axios
        .get("/labels")
        .then((res) => {
          this.labels = res.data;
        })
        .catch(error => {
          this.forceLogout(error);
        });
    },
    setTodoValue(val) {
      this.toggleModal();
      this.todo.id = val.id;
      this.todo.title = val.title;
      this.todo.body = val.body;
      this.todo.todo_date = val.todo_date || this.formattedDate;
      this.todo.label_id = val.label_id;
      this.btnText = val.id ? "更新する" : "新規作成";
    },
    todoSubmit() {

      const label_arr = [];
      if (this.todo.label_id) {
        label_arr.push(this.todo.label_id);
      }

      if (this.todo.id) {
        axios
          .put(`/todos/${this.todo.id}`, { 
            todo: {
              title: this.todo.title,
              status: this.todo.status,
              body: this.todo.body,
              todo_date: this.todo.todo_date,
              label_ids: label_arr
            }
          })
          .then(() => {
            this.toggleModal();
            this.setSelectedDateAction(this.todo.todo_date);
            this.todo = {};
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      } else {
        axios
          .post("/todos", {
            todo: {
              title: this.todo.title,
              status: this.todo.status,
              body: this.todo.body,
              todo_date: this.todo.todo_date,
              label_ids: label_arr
            }
          })
          .then(() => {
            this.toggleModal();
            this.setSelectedDateAction(this.todo.todo_date);
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
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
                  v-model="todo_title"
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
                  v-model="todo_date"
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
                <select v-model="label_id" class="form__select">
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
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">メモ</div>
              </div>
              <div class="col-9">
                <input type="text" class="form__input" v-model="todo_body" />
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
      todo_id: "",
      todo_title: "",
      todo_date: "",
      todo_body: "",
      label_id: [],
      btnText: "",
    };
  },
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
  mixins: [Modal, ColorOnRgb],
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction"
    }),
    fetchLabels() {
      axios
        .get("/api/labels")
        .then((res) => {
          this.labels = res.data;
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
      this.todo_id = hasValue() ? val.todo_id : undefined;
      this.todo_title = hasValue() ? val.todo_title : undefined;
      this.label_id = hasValue() ? val.label_id : undefined;
      this.todo_body = hasValue() ? val.todo_body : undefined;
      this.todo_date = hasValue() ? val.todo_date : this.formattedDate;
      this.btnText = hasValue() ? "更新する" : "新規作成";
    },
    todoSubmit() {
      const label_arr = [];
      if (this.label_id) {
        label_arr.push(this.label_id);
      }

      if (this.todo_id) {
        axios
          .put(`/api/todos/${this.todo_id}`, { 
            todo: {
              title: this.todo_title,
              status: this.todo_status,
              body: this.todo_body,
              todo_date: this.todo_date,
              label_ids: label_arr
            }
          })
          .then(() => {
            this.toggleModal();
            this.setSelectedDateAction(this.todo_date);
            this.todo = {};
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      } else {
        axios
          .post("/api/todos", {
            todo: {
              title: this.todo_title,
              status: this.todo_status,
              body: this.todo_body,
              todo_date: this.todo_date,
              label_ids: label_arr
            }
          })
          .then(() => {
            this.toggleModal();
            this.setSelectedDateAction(this.todo_date);
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

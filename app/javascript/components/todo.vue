<template>
  <div class="content">
    <div class="todo">
      <section class="horizontal-arrows">
        <div
          @click="changeDay(previous_date)"
          class="horizontal-arrows__btn horizontal-arrows__btn--left"
        >
          <i class="fas fa-caret-left"></i>
        </div>
        <div class="todo__date-box">
          <div class="todo__date-title">{{ selected_format_date }}</div>
          <p class="todo__date-day">曜日</p>
        </div>
        <div
          @click="changeDay(next_date)"
          class="horizontal-arrows__btn horizontal-arrows__btn--right"
        >
          <i class="fas fa-caret-right"></i>
        </div>
      </section>
      <div v-if="todos.length">
        <ul v-for="todo in todos" class="list" :key="todo.id">
          <li class="list__item">
            <div id="todo-<%= todo.id %>" class="todo-status"></div>
            <div class="list__block list__block--left">
              <div class="list__title">{{ todo.title }}</div>
            </div>
            <div class="list__block list__block--right list__block--grow">
              <label
                class="label label--margin"
                style="background-color: #<%= label.color %>;"
              >
              </label>
              <div class="item-action">
                <a @click="modalEditTodo(todo)" class="item-action__btn">
                  <i class="fas fa-pencil-alt"></i>
                </a>
                <a @click="deleteTodo(todo.id)" class="item-action__btn">
                  <i class="fas fa-trash"></i>
                </a>
              </div>
            </div>
          </li>
        </ul>
      </div>
      <div v-else class="no-result todo__no-result">
        <div class="no-result__illustration">
          <img
            src="/illustrations/il-checklist.png"
            alt="チェックリストのイラスト"
          />
        </div>
      </div>
      <div class="todo__page-action page-action">
        <a @click="openModal" class="btn-outlined btn--sm">
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text modal-trigger">ToDoを追加</span>
        </a>
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
                    v-if="modalEditingTodo"
                    v-model="modalEditingTodo.title"
                    required
                  />
                  <input
                    type="text"
                    class="form__input"
                    v-else
                    v-model="todo.title"
                    required
                  />
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    ラベル
                  </div>
                </div>
                <div class="col-9">
                  <select
                    v-if="modalEditingTodo"
                    v-model="modalEditingTodo.label_id"
                    class="form__select"
                  >
                    <option>ラベルを選択</option>
                    <option
                      v-for="label in labels"
                      :key="label.id"
                      :value="label.id"
                      >{{ label.title }}</option
                    >
                  </select>
                  <select v-else v-model="todo.label_id" class="form__select">
                    <option selected value="">ラベルを選択</option>
                    <option
                      v-for="label in labels"
                      :key="label.id"
                      :value="label.id"
                      >{{ label.title }}</option
                    >
                  </select>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    開始日
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="date"
                    name="start_date"
                    class="form__input"
                    :default="selected_date"
                    :value="selected_date"
                  />
                </div>
              </div>
              <div class="form__group row form__group--end-day">
                <div class="col-3">
                  <div class="form__label">
                    終了日
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="date"
                    name="end_date"
                    class="form__input"
                    :default="selected_date"
                    :value="selected_date"
                  />
                  <div class="remember-me">
                    <div class="remember-me__checkbox">
                      <input
                        type="checkbox"
                        name="remember_me"
                        id="remember_me"
                      />
                      <label for="remember_me">終了日を設定せず繰り返す</label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    曜日指定
                  </div>
                </div>
                <div class="col-9">
                  <div class="day-check">
                    <label v-for="n in 7" class="day-check__label" :key="n - 1">
                      <input
                        type="checkbox"
                        name="apply_days"
                        class="day-check__input"
                        multiple
                        checked
                      />
                      <span>{{ days[n - 1] }}</span>
                    </label>
                  </div>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    メモ
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="text"
                    class="form__input"
                    v-if="modalEditingTodo"
                    v-model="modalEditingTodo.body"
                  />
                  <input
                    type="text"
                    class="form__input"
                    v-else
                    v-model="todo.body"
                  />
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3">
                  <div class="form__label">
                    達成度を表示
                  </div>
                </div>
                <div class="col-9">
                  <div class="btn-slide">
                    <input
                      type="checkbox"
                      name="history_selected"
                      id="history_selected"
                      class="btn-slide__input"
                    />
                    <label
                      for="history_selected"
                      class="btn-slide__label"
                    ></label>
                  </div>
                </div>
              </div>
              <div class="btn-case">
                <div @click="closeModal" class="btn-gray btn--sm">
                  キャンセル
                </div>
                <div
                  @click="updateTodo(modalEditingTodo)"
                  class="btn-main btn--sm"
                  v-if="modalEditingTodo"
                >
                  更新する
                </div>
                <div @click="createTodo" class="btn-main btn--sm" v-else>
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
      todo: {
        title: ""
      },
      labels: [],
      days: ["日", "月", "火", "水", "木", "金", "土"],
      selected_date: null,
      selected_format_date: null,
      previous_date: null,
      previous_format_date: null,
      next_date: null,
      next_format_date: null,
      errors: [],
      editingTodoId: null,
      editedTodo: null,
      modalEditingTodo: null
    };
  },
  created() {
    this.fetchData();
  },
  methods: {
    setResponse(res) {
      const data = res.data;
      this.todos = data.todos;
      this.labels = data.labels;
      this.selected_date = data.selected_date;
      this.selected_format_date = data.selected_format_date;
      this.previous_date = data.previous_date;
      this.previous_format_date = data.previous_format_date;
      this.next_date = data.next_date;
      this.next_format_date = data.next_format_date;
    },
    fetchData() {
      axios
        .get("/api/todos.json")
        .then((response) => this.setResponse(response));
    },
    changeDay(date) {
      axios
        .get("/api/todos.json", { params: { date: date } })
        .then((response) => this.setResponse(response));
    },
    createTodo(todo) {
      this.errors = [];
      if (!this.todo.title) {
        this.errors.push("タイトルは必須です");
        return;
      }
      axios
        .post("/api/todos", {
          todo: this.todo
        })
        .then(
          (res) => {
            this.todo.title = "";
            this.fetchData();
            this.closeModal();
          },
          (error) => {
            this.errors.push("エラー発生");
          }
        );
    },
    editTodo(todo) {
      this.fetchData();
      this.editingTodoId = todo.id;
    },
    modalEditTodo(todo) {
      this.modalEditingTodo = todo;
      this.openModal();
      this.fetchData();
    },
    updateTodo(todo) {
      this.errors = [];
      if (!todo.title) {
        return;
      }
      this.closeModal();
      this.editedTodo = todo;
      axios.put(`/api/todos/${todo.id}`, { todo: this.editedTodo }).then(
        (res) => {
          this.modalEditingTodo = null;
          this.fetchData();
        },
        (error) => {
          this.errors.push("エラーがあります");
        }
      );
    },
    deleteTodo(id) {
      axios.delete(`/api/todos/${id}`).then((res) => {
        this.fetchData();
      });
    },
    openModal() {
      this.isModalActive = true;
    },
    closeModal() {
      this.isModalActive = false;
      this.modalEditingTodo = null;
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

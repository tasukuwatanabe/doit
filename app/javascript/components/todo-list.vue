<template>
  <div class="content">
    <div class="todo">
      <section class="horizontal-arrows">
        <div
          @click="fetchDate(setYesterday)"
          class="horizontal-arrows__btn horizontal-arrows__btn--left"
        >
          <i class="fas fa-caret-left"></i>
        </div>
        <div class="todo__date-box">
          <div class="todo__date-title">
            {{ setSelectedDate }}
          </div>
          <p class="todo__date-day">{{ setDay }}</p>
        </div>
        <div
          @click="fetchDate(setTomorrow)"
          class="horizontal-arrows__btn horizontal-arrows__btn--right"
        >
          <i class="fas fa-caret-right"></i>
        </div>
      </section>
      <v-loading-icon v-show="loading"></v-loading-icon>
      <div v-show="!loading">
        <ul class="list" v-if="todos.length">
          <li v-for="todo in todos" class="list__item" :key="todo.id">
            <div
              class="todo-status"
              :class="{ 'todo__status--checked': todo.todo_status }"
            >
              <input
                :id="'todo_status_' + todo.id"
                type="checkbox"
                v-model="todo.status"
                @click="toggleStatus(todo)"
              />
              <label :for="'todo_status_' + todo.id"></label>
            </div>
            <div class="list__block list__block--left">
              <div class="list__title">{{ todo.title }}</div>
            </div>
            <div class="list__block list__block--right list__block--grow">
              <div
                class="label label--margin"
                v-if="todo.label_color"
                :style="{
                  color: colorOnRgb(todo.label_color),
                  backgroundColor: todo.label_color
                }"
              >
                {{ todo.label_title }}
              </div>
              <div v-else></div>
              <div class="item-action">
                <a @click="setTodo(todo)" class="item-action__btn">
                  <i class="fas fa-pencil-alt"></i>
                </a>
                <a @click="deleteTodo(todo)" class="item-action__btn">
                  <i class="fas fa-trash"></i>
                </a>
              </div>
            </div>
          </li>
        </ul>
        <div v-else class="no-result todo__no-result">
          <div class="no-result__illustration">
            <img
              src="/illustrations/il-checklist.png"
              alt="チェックリストのイラスト"
            />
          </div>
          <div class="no-result__text">まだToDoが作成されていません</div>
        </div>
      </div>
      <div class="todo__page-action page-action">
        <a @click="setTodo" class="btn-outlined btn--sm">
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text modal-trigger">ToDoを追加</span>
        </a>
      </div>
    </div>
    <todo-modal @fetch-todos="fetchTodos" ref="todoModal"></todo-modal>
  </div>
</template>

<script>
import Vue from "vue";
import axios from "axios";
import { mapGetters, mapActions } from "vuex";
import TodoModal from "./todo-modal.vue";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  components: {
    "todo-modal": TodoModal
  },
  data() {
    return {
      todos: [],
      loading: ''
    };
  },
  mixins: [ColorOnRgb],
  created() {
    this.loading = true;
    this.fetchDate();
  },
  watch: {
    getSelectedDate: function() {
      this.fetchTodos(this.getSelectedDate);
    }
  },
  computed: {
    ...mapGetters({
      getSelectedDate: "date/getSelectedDate",
    }),
    setSelectedDate() {
      const selected_date = new Date(this.getSelectedDate);
      const year = selected_date.getFullYear();
      const month = selected_date.getMonth() + 1;
      const date = selected_date.getDate();

      return `${year}年${month}月${date}日`;
    },
    setDay() {
      const weeks = ["日", "月", "火", "水", "木", "金", "土"];
      const selected_date = new Date(this.getSelectedDate);
      const week = selected_date.getDay();

      return `${weeks[week]}曜日`;
    },
    setYesterday() {
      const selected_date = new Date(this.getSelectedDate);
      const yesterday = selected_date.setDate(selected_date.getDate() - 1);
      return new Date(yesterday);
    },
    setTomorrow() {
      const selected_date = new Date(this.getSelectedDate);
      const tomorrow = selected_date.setDate(selected_date.getDate() + 1);
      return new Date(tomorrow);
    }
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction",
      cancelPendingRequests: "request/cancelPendingRequests"
    }),
    fetchDate(date) {
      this.setSelectedDateAction(date);
    },
    fetchTodos(date) {
      this.cancelPendingRequests();
      axios
        .get("/api/todos", { params: { date: date } })
        .then((res) => {
          this.todos = res.data;
          this.loading = false;
        })
        .catch(error => {
          console.log("通信がキャンセルされました");
        });
    },
    setTodo(todo) {
      this.$refs.todoModal.setTodoValue(todo);
    },
    deleteTodo(todo) {
      axios
        .delete(`/api/todos/${todo.id}`)
        .then(() => {
          this.fetchTodos(this.getSelectedDate);
        });
    },
    toggleStatus(todo) {
      axios.put(`/api/todos/${todo.id}/toggle_status`, { todo: todo });
    }
  }
};
</script>

<style scoped>
.loading-case {
  width: 100%;
  height: 300px;
}
</style>
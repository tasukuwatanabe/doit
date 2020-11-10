<template>
  <div>
    <div class="container inner">
      <sidebar-left></sidebar-left>
      <div class="content">
        <div class="todo">
          <section class="horizontal-arrows">
            <div
              @click="fetchDate('previous')"
              class="horizontal-arrows__btn horizontal-arrows__btn--left"
            >
              <i class="fas fa-caret-left"></i>
            </div>
            <div class="todo__date-box">
              <div class="todo__date-title">
                {{ setDate }}
              </div>
              <p class="todo__date-day">{{ setDay }}</p>
            </div>
            <div
              @click="fetchDate('next')"
              class="horizontal-arrows__btn horizontal-arrows__btn--right"
            >
              <i class="fas fa-caret-right"></i>
            </div>
          </section>
          <ul class="list" v-if="todos.length">
            <li v-for="todo in todos" class="list__item" :key="todo.id">
              <div
                class="todo-status"
                :class="{ 'todo__status--checked': todo.status }"
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
                  v-if="getTodoLabel(todo)"
                  :style="{
                    color: colorOnRgb(getTodoLabel(todo).color),
                    backgroundColor: getTodoLabel(todo).color
                  }"
                >
                  {{ getTodoLabel(todo).title }}
                </div>
                <div v-else></div>
                <div class="item-action">
                  <a @click="setTodo(todo)" class="item-action__btn">
                    <i class="fas fa-pencil-alt"></i>
                  </a>
                  <a @click="deleteTodo(todo.id)" class="item-action__btn">
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
        <todo-shortcut @fetch-todos="fetchTodos"></todo-shortcut>
      </div>
      <sidebar-right></sidebar-right>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapActions } from "vuex";
import TodoShortcut from "./todo-shortcut.vue";
import TodoModal from "./todo-modal.vue";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  components: {
    "todo-shortcut": TodoShortcut,
    "todo-modal": TodoModal
  },
  data() {
    return {
      todos: [],
      shortcuts: [],
      labels: []
    };
  },
  mixins: [ColorOnRgb],
  created() {
    this.fetchDate();
    this.fetchTodos();
  },
  computed: {
    ...mapGetters(["selectedDate"]),
    setDate() {
      const selected_date = this.selectedDate
        ? new Date(this.selectedDate)
        : new Date();
      const year = selected_date.getFullYear();
      const month = selected_date.getMonth() + 1;
      const date = selected_date.getDate();

      return `${year}年${month}月${date}日`;
    },
    setDay() {
      const weeks = ["日", "月", "火", "水", "木", "金", "土"];
      const selected_date = this.selectedDate
        ? new Date(this.selectedDate)
        : new Date();
      const week = selected_date.getDay();

      return `${weeks[week]}曜日`;
    }
  },
  methods: {
    ...mapActions(["setDateAction"]),
    fetchDate(select) {
      this.setDateAction(select);
    },
    fetchTodos(date) {
      axios.get("/api/todos", { params: { date: date } }).then((res) => {
        this.todos = res.data.todos;
      });
    },
    getTodoLabel(todo) {
      return this.labels.filter((label) => todo.label_id == label.id)[0];
    },
    setTodo(label) {
      this.$refs.todoModal.setTodoValue(todo);
    },
    deleteTodo(id) {
      axios.delete(`/api/todos/${id}`).then((res) => {
        this.changeDate(this.$store.getters.selectedDate);
      });
    },
    toggleStatus(todo) {
      axios.put(`/api/todos/${todo.id}/toggle_status`, { todo: todo });
    }
  }
};
</script>

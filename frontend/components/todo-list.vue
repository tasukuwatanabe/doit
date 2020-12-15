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
      <div class="loading-case" v-if="loading">
        <div class="spinner-border text-info" role="status">
          <span class="sr-only">Loading...</span>
        </div>
      </div>
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
              <div>
                <LabelItem :label-item="todo.label" v-if="todo.label_color" />
              </div>
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
              src="../images/illustrations/il-checklist.png"
              alt="チェックリストのイラスト"
            />
          </div>
          <div class="no-result__text">まだToDoが作成されていません</div>
        </div>
      </div>
      <div class="todo__page-action page-action">
        <a @click="setTodo" class="btn btn--main btn--md">
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text modal-trigger">ToDoを追加</span>
        </a>
      </div>
    </div>
    <TodoModal @fetch-todos="fetchTodos" ref="todoModal" />
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapActions } from "vuex";
import TodoModal from "./todo-modal";
import LabelItem from "./label-item";

export default {
  components: {
    TodoModal,
    LabelItem
  },
  data() {
    return {
      todos: [],
      loading: ''
    };
  },
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
      cancelPendingRequests: "request/cancelPendingRequests",
      logoutAction: "user/logoutAction"
    }),
    fetchDate(date) {
      this.setSelectedDateAction(date);
    },
    fetchTodos(date) {
      this.cancelPendingRequests();
      axios
        .get("/todos", { params: { date: date } })
        .then((res) => {
          this.todos = res.data;
          for (let i = 0; i < this.todos.length; i++) {
            this.todos[i].label = {
              title: this.todos[i].label_title,
              color: this.todos[i].label_color
            }
          }
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          if (error.response && error.response.status === 500) {
            axios.delete("/logout").then(() => {
              this.logoutAction();
              this.$router.push({ name: "login" });
              this.flashMessage.error({
                title: "再度ログインしてください",
                time: 5000,
                icon: '/icons/error.svg',
              });
            });
          }
        });
    },
    setTodo(todo) {
      this.$refs.todoModal.setTodoValue(todo);
    },
    deleteTodo(todo) {
      axios
        .delete(`/todos/${todo.id}`)
        .then(() => {
          this.fetchTodos(this.getSelectedDate);
        });
    },
    toggleStatus(todo) {
      axios.put(`/todos/${todo.id}/toggle_status`, { todo: todo });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "../stylesheets/variables.scss";
@import "../stylesheets/extend.scss";

.loading-case {
  width: 100%;
  height: 300px;
}

.todo {
  &__date-box {
    text-align: center;
    user-select: none;
  }

  &__date-title {
    font-size: 1.6em;
    margin-bottom: 0.1em;
  }

  &__date-day {
    margin: 0;
    font-size: 0.8em;
  }

  &__page-action {
    text-align: center;
  }

  &__no-result {
    margin-bottom: 20px;
    text-align: center;
    background-color: #fff;
    padding: 60px 0;
    box-shadow: $box-shadow-common;

    @media (max-width: 767px) {
      margin-top: 30px;
    }

    .no-result {
      &__illustration {
        width: 300px;
        margin: 0 auto 20px;

        @media (max-width: 767px) {
          width: 80%;
        }
      }
    }
  }

  .list {
    box-shadow: $box-shadow-common;
    
    &__item {
      padding-left: 62px;
    }
  }
}

.todo-status {
  position: relative;
  width: 32px;
  height: 32px;
  margin-right: 15px;

  &--checked {
    & + .todo__title {
      color: #bbb;
    }
  }

  label {
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 50%;
    cursor: pointer;
    height: 32px;
    left: 0;
    position: absolute;
    top: 0;
    width: 32px;

    &:after {
      border: 2px solid #fff;
      border-top: none;
      border-right: none;
      content: "";
      height: 8px;
      left: 8px;
      opacity: 0;
      position: absolute;
      top: 9px;
      transform: rotate(-45deg);
      width: 15px;
    }
  }

  input[type="checkbox"] {
    visibility: hidden;

    &:checked + label {
      background-color: $color-main-theme;
      border-color: $color-main-theme;

      &:after {
        opacity: 1;
      }
    }
  }
}

.horizontal-arrows {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;

  &__btn {
    @extend %link;
    width: 30px;
    height: 30px;
    border: 1px solid $color-main-theme;
    background-color: #fff;
    border-radius: 5px;
    display: flex;
    justify-content: center;
    align-items: center;
    transition-duration: 0.2s;

    &:hover {
      background-color: $color-main-theme;

      svg {
        color: #fff;
      }
    }

    & > * {
      position: relative;
      color: $color-main-theme;
    }

    &--left {
      svg {
        left: -1px;
      }
    }

    &--right {
      svg {
        right: -1px;
      }
    }
  }
}
</style>
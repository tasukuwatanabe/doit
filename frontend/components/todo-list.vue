<template>
  <div class="content">
    <div class="todo">
      <section class="horizontal-arrows">
        <div
          @click="setDate(setPreviousDay)"
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
          @click="setDate(setNextDay)"
          class="horizontal-arrows__btn horizontal-arrows__btn--right"
        >
          <i class="fas fa-caret-right"></i>
        </div>
      </section>
      <ul class="list" v-if="this.getTodos.length">
        <li v-for="todo in this.getTodos" class="list__item" :key="todo.id">
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
          <div class="list__inner">
            <div class="list__block list__block--left">
              <div class="list__title" :class="{ 'list__title--with-label' : todo.label_title }">{{ todo.title }}</div>
              <LabelItem :target-item="todo" v-if="todo.label_id" />
            </div>
            <div class="list__block list__block--right">
              <ItemAction :item="todo" @set-item="setTodo" @delete-item="deleteTodo" />
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
import { axios, axiosForBackend } from "../config/axios";
import { mapGetters, mapActions } from "vuex";
import { moment, formatMomentToString } from "../modules/myMoment";
import ItemAction from "./shared/item-action";
import TodoModal from "./todo-modal";
import LabelItem from "./label-item";
import Logout from "./mixins/logout";

export default {
  components: {
    ItemAction,
    TodoModal,
    LabelItem,
  },
  mixins: [Logout],
  watch: {
    getSelectedDate() {
      this.fetchTodos(this.getSelectedDate);
    }
  },
  computed: {
    ...mapGetters({
      getSelectedDate: "date/getSelectedDate",
      getTodos: "todo/getTodos"
    }),
    setSelectedDate() {
      const selected_date = moment(this.getSelectedDate);
      const year = selected_date.year();
      const month = selected_date.month() + 1;
      const date = selected_date.date();

      return `${year}年${month}月${date}日`;
    },
    setDay() {
      return moment(this.getSelectedDate).format('dd') + '曜日';
    },
    setPreviousDay() {
      return moment(this.getSelectedDate).subtract(1, 'days');
    },
    setNextDay() {
      return moment(this.getSelectedDate).add(1, 'days');
    }
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction",
      setTodosAction: "todo/setTodosAction",
    }),
    setDate(date) {
      this.setSelectedDateAction(date);
    },
    fetchTodos(date) {
      axiosForBackend
        .get("/todos", { params: { date: formatMomentToString(date) }})
        .then((res) => {
          this.setTodosAction(res.data);
        })
        .catch(error => {
          this.forceLogout(error);
        });
    },
    setTodo(todo) {
      this.$refs.todoModal.setTodoValue(todo);
    },
    deleteTodo(todo) {
      axiosForBackend
        .delete(`/todos/${todo.id}`)
        .then(() => {
          this.fetchTodos(this.getSelectedDate);
        });
    },
    toggleStatus(todo) {
      axios.put(`/todos/${todo.id}/toggle_status`);
    }
  }
};
</script>

<style lang="scss" scoped>
@import "../stylesheets/variables.scss";
@import "../stylesheets/extend.scss";
@import "../stylesheets/mixin.scss";

.todo {
  &__date-box {
    text-align: center;
    user-select: none;
  }

  &__date-title {
    font-size: 1.6em;
  }

  &__date-day {
    margin: 0;
    font-size: 0.8em;
  }

  &__page-action {
    text-align: center;
    @media (max-width: 991px) {
      margin-bottom: 30px;
    }
  }

  &__no-result {
    margin-bottom: 20px;
    text-align: center;
    background-color: #fff;
    padding: 60px 0;
    box-shadow: $box-shadow-common;

    @media (max-width: 991px) {
      margin-top: 20px;
    }

    .no-result {
      &__illustration {
        width: 300px;
        margin: 0 auto 20px;

        @media (max-width: 991px) {
          width: 80%;
        }
      }
    }
  }

  .list {
    box-shadow: $box-shadow-common;
    
    &__item {
      padding-left: 62px;

      @media (max-width: 374px) {
        padding-left: 55px;
      }
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

    @media (min-width: 992px) {
      &:hover {
        background-color: $color-main-theme;

        svg {
          color: #fff;
        }
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

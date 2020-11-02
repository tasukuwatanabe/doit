<template>
  <div class="content">
    <div class="todo">
      <section class="horizontal-arrows">
        <div class="horizontal-arrows__btn horizontal-arrows__btn--left">
          <i class="fas fa-caret-left"></i>
        </div>
        <div class="todo__date-box">
          <div class="todo__date-title">2020年11月2日</div>
          <p class="todo__date-day">曜日</p>
        </div>
        <div class="horizontal-arrows__btn horizontal-arrows__btn--right">
          <i class="fas fa-caret-right"></i>
        </div>
      </section>
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
      errors: [],
      editingTodoId: null,
      editedTodo: null,
      modalEditingTodo: null
    };
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

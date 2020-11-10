<template>
  <div class="index-shortcut">
    <div class="index-shortcut__box">
      <div class="index-shortcut__title">ショートカットからToDoを作成</div>
      <router-link to="/shortcuts" class="index-shortcut__edit">
        編集
      </router-link>
    </div>
    <div class="index-shortcut__field">
      <ul v-if="shortcuts" class="index-shortcut__list">
        <li
          v-for="shortcut in shortcuts"
          :key="shortcut.id"
          class="index-shortcut__item"
        >
          <a @click="createTodo(shortcut)" class="index-shortcut__link">{{
            shortcut.title
          }}</a>
        </li>
      </ul>
      <div v-else class="index-shortcut__no-result">
        <p class="index-shortcut__text">ショートカットが作成されていません。</p>
        <div class="page-action">
          <router-link to="/shortcuts" class="btn-outlined btn--sm">
            <span class="page-action__icon">
              <i class="fas fa-plus"></i>
            </span>
            <span class="page-action__text">ショートカットを追加</span>
          </router-link>
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
      todo: {},
      shortcuts: []
    };
  },
  created() {
    this.fetchShortcut();
  },
  methods: {
    fetchShortcut() {
      axios.get("/api/shortcuts").then((res) => {
        this.shortcuts = res.data;
      });
    },
    createTodo(shortcut) {
      this.todo.title = shortcut.title;
      this.$emit("shortcut-create-todo", this.todo.title);
    }
  }
};
</script>

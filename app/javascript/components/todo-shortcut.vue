<template>
  <div class="index-shortcut">
    <div class="index-shortcut__box">
      <div class="index-shortcut__title">ショートカットからToDoを作成</div>
      <router-link
        to="/shortcuts"
        v-if="shortcuts.length"
        class="index-shortcut__edit"
      >
        編集
      </router-link>
    </div>
    <div class="index-shortcut__field">
      <ul v-if="shortcuts.length" class="index-shortcut__list">
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
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      shortcuts: []
    };
  },
  created() {
    this.fetchShortcut();
  },
  computed: {
    ...mapGetters({
      selectedDate: "date/selectedDate"
    })
  },
  methods: {
    fetchShortcut() {
      axios.get("/api/shortcuts").then((res) => {
        this.shortcuts = res.data.shortcuts;
      });
    },
    createTodo(shortcut) {
      const todo_params = {
        title: shortcut.title,
        todo_date: this.selectedDate,
        label_id: shortcut.label_id
      };
      axios.post("/api/todos", { todo: todo_params }).then(() => {
        this.$emit("fetch-todos", this.selectedDate);
      });
    }
  }
};
</script>

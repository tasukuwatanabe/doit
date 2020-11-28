<template>
  <div class="sidebar-shortcut">
    <div class="sidebar-shortcut__box">
      <div class="sidebar-shortcut__title">ショートカットからToDo作成</div>
      <router-link
        to="/shortcuts"
        v-if="!!shortcuts"
        class="sidebar-shortcut__edit"
      >
        編集
      </router-link>
    </div>
    <div 
      class="sidebar-shortcut__field" 
      :class="{ 'sidebar-shortcut__field--center' : (loading || !shortcuts.length) }">
      <v-loading-icon v-show="loading"></v-loading-icon>
      <div v-show="!loading">
        <ul v-if="shortcuts.length" class="sidebar-shortcut__list">
          <li
            v-for="shortcut in shortcuts"
            :key="shortcut.id"
            class="sidebar-shortcut__item"
          >
            <a @click="createTodo(shortcut)" class="sidebar-shortcut__link">
              <i class="fas fa-plus-circle"></i>
              {{ shortcut.title }}
            </a>
          </li>
        </ul>
        <div v-else class="sidebar-shortcut__no-result">
          <p class="sidebar-shortcut__text">ショートカットが未作成です</p>
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
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      shortcuts: [],
      loading: ''
    };
  },
  created() {
    this.loading = true;
    this.fetchShortcut();
  },
  computed: {
    ...mapGetters({
      getSelectedDate: "date/getSelectedDate",
    })
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction"
    }),
    fetchShortcut() {
      axios
        .get("/api/shortcuts")
        .then((res) => {
          this.shortcuts = res.data;
          this.loading = false;
        }).catch(error => {
          console.log("通信がキャンセルされました");
          this.loading = false;
        });
    },
    createTodo(shortcut) {
      const label_arr = [];
      label_arr.push(shortcut.label_id);
      axios.post("/api/todos", {
        todo: {
          title: shortcut.title,
          todo_date: this.getSelectedDate,
          label_ids: label_arr
        }
      }).then(() => {
        this.setSelectedDateAction(this.getSelectedDate);
      });
    }
  }
};
</script>

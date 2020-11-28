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
      <div class="spinner-border text-info" v-if="loading" role="status">
        <span class="sr-only">Loading...</span>
      </div>
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

<style lang="scss" scoped>
@import "../../stylesheets/variables.scss";
@import "../../stylesheets/extend.scss";

.sidebar-shortcut {
  &__field {
    padding: 10px;
    background-color: #fff;
    text-align: center;
    box-shadow: $box-shadow-common;
    min-height: 250px;

    &--center {
      display: flex;
      justify-content: center;
      align-items: center;
    }

    @media (max-width: 767px) {
      padding: 10px;
    }
  }

  &__box {
    display: flex;
    justify-content: space-between;
    margin-bottom: 7px;
  }

  &__title {
    font-size: .9em;
    font-weight: bold;
  }

  &__edit {
    text-decoration: underline;
    color: $color-main-theme;
    font-size: 0.9em;
  }

  &__list {
    list-style-type: none;
    display: flex;
    flex-wrap: wrap;
    padding: 0;
    margin: 0;
  }

  &__item {
    background-color: #fff;
    border-radius: 100px;
    margin: 5px;
    font-size: 0.9em;
  }

  &__link {
    @extend %link;
    color: $color-base-font;
    padding: 3px 8px;
    border-radius: 3px;
    display: block;
    background-color: #eee;

    svg {
      color: #999;
    }
  }

  &__text {
    margin-bottom: 20px;
    font-size: 0.8em;
  }

  .page-action {
    font-size: 0.9em;
  }
}
</style>
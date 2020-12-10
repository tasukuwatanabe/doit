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
            <router-link to="/shortcuts" class="btn btn--outlined">
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
      setSelectedDateAction: "date/setSelectedDateAction",
      logoutAction: "user/logoutAction"
    }),
    fetchShortcut() {
      axios
        .get("/api/v1/shortcuts")
        .then((res) => {
          this.shortcuts = res.data;
          this.loading = false;
        }).catch(error => {
          this.loading = false;
          if (error.response && error.response.status === 500) {
            axios.delete("/api/v1/logout").then(() => {
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
    createTodo(shortcut) {
      const label_arr = [];
      label_arr.push(shortcut.label_id);
      axios.post("/api/v1/todos", {
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
    font-size: 0.9em;
  }

  .page-action {
    border: 1px solid $color-main-theme;
    background-color: #fff;
    border-radius: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    transition-duration: 0.2s;
    padding: 2px 7px;

    a {
      font-size: 0.9em !important;
      color: $color-main-theme !important;

      &:hover {
        opacity: .8;
      }
    }
  }
}
</style>
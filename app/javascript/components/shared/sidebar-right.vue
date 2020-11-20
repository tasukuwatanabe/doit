<template>
  <aside v-if="this.getCurrentUser && is_todo" class="sidebar">
    <div class="sidebar__stickey-part sidebar-right">
      <section class="sidebar-right__search search">
        <div class="search__form">
          <span class="fa fa-search"></span>
          <input type="text" class="search__input" v-model="query" @keyup="todoSearch" />
        </div>
      </section>
      <div v-if="query && query.length" class="search__box">
        <template v-if="results && results.length">
          <div v-for="resultDate in resultDateArray" :key="resultDate">
            <div class="search__date">
                {{ resultFormatDate(resultDate) }}
            </div>
            <div class="search__list">
              <div v-for="result in todoByDate(resultDate)" @click="fetchDate(result.todo_date)" :key="result.id" class="search__item">{{ result.title }}
                <div class="label"
                      v-if="todoLabel(result)"
                      :style="{color: colorOnRgb(todoLabel(result).color), backgroundColor: todoLabel(result).color }">
                  {{ todoLabel(result).title }}
                </div>
              </div>
            </div>
          </div>
        </template>
        <div v-else class="search__no-result">結果なし</div>
      </div>
      <div v-else>
        <sidebar-calendar></sidebar-calendar>
        <sidebar-shortcut></sidebar-shortcut>
      </div>
    </div>
  </aside>
</template>

<script>
import axios from "axios";
import moment from "moment";
import { mapGetters, mapActions } from "vuex";
import ColorOnRgb from "../mixins/color-on-rgb";
import SidebarCalendar from "../shared/sidebar-calendar";
import SidebarShortcut from "../shared/sidebar-shortcut.vue";

export default {
  data() {
    return {
      query: '',
      results: [],
      labels: []
    }
  },
  components: {
    'sidebar-calendar': SidebarCalendar,
    "sidebar-shortcut": SidebarShortcut,
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser",
    }),
    resultDateArray() {
      let resultDates = [];
      for (let i = 0; i < this.results.length; i++) {
        if (i === 0 || !resultDates.includes(this.results[i].todo_date)) {
          resultDates.push(this.results[i].todo_date);
        }
      }
      return resultDates;
    },
    resultFormatDate() {
      return function(date) {
        return moment(date).format('YYYY年M月D日');
      }
    },
    todoByDate() {
      return function (date) {
        return this.results.filter(result => result.todo_date === date);
      }
    },
    setSelectedDate() {
      return function (todo_date) {
        const selected_date = new Date(todo_date);
        const year = selected_date.getFullYear();
        const month = selected_date.getMonth() + 1;
        const date = selected_date.getDate();

        return `${year}年${month}月${date}日`;
      }
    },
    is_todo() {
      return this.$route.name === 'todos';
    },
    todoLabel() {
      return function (todo) {
        return this.labels.filter((label) => todo.label_id == label.id)[0];
      };
    }
  },
  mixins: [ColorOnRgb],
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction"
    }),
    fetchDate(todo_date) {
      this.setSelectedDateAction(todo_date);
    },
    todoSearch() {
      if (this.query == '') {
        return;
      }
      axios
        .get('/api/search', {
          params: {
            query: this.query
          }
        })
        .then((res) => {
          this.results = res.data.todos;
          this.labels = res.data.labels;
        });
    }
  }
}
</script>
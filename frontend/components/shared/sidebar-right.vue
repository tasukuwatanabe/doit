<template>
  <aside v-if="isTodo" class="sidebar sidebar-right">
    <div v-if="this.getCurrentUser" class="sidebar--stickey sidebar-right__inner">
      <section class="sidebar-right__search search">
        <div class="search__form">
          <i class="fa fa-search search__lense"></i>
          <input type="text" class="search__input" v-model="query" @keyup="todoSearch" />
          <div v-if="query" class="search__reset" @click="resetQuery">
            <i class="fas fa-times-circle"></i>
          </div>
        </div>
      </section>
      <div v-if="query" class="search__box">
        <div class="loading-case" v-if="loading">
          <div class="spinner-border text-info" role="status">
            <span class="sr-only">Loading...</span>
          </div>
        </div>
        <div v-show="!loading">
          <template v-if="results && results.length">
            <div v-for="resultDate in resultDateArray" :key="resultDate">
              <div class="search__date">
                  {{ resultFormatDate(resultDate) }}
              </div>
              <div class="search__list">
                <div v-for="result in todoByDate(resultDate)" @click="fetchDate(result.todo_date)" :key="result.id" class="search__item">{{ result.title }}
                  <label-item :label-item="result.label" v-if="result.label_color"></label-item>
                </div>
              </div>
            </div>
          </template>
          <div v-else class="search__no-result">結果なし</div>
        </div>
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
import SidebarCalendar from "./sidebar-calendar";
import SidebarShortcut from "./sidebar-shortcut";
import LabelItem from "../label-item";

export default {
  data() {
    return {
      query: '',
      results: [],
      loading: ''
    }
  },
  components: {
    'sidebar-calendar': SidebarCalendar,
    "sidebar-shortcut": SidebarShortcut,
    "label-item": LabelItem
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser"
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
    isTodo() {
      return this.$route.name === 'todos';
    }
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction",
      cancelPendingRequests: "request/cancelPendingRequests"
    }),
    fetchDate(todo_date) {
      this.setSelectedDateAction(todo_date);
    },
    todoSearch() {
      if (this.query == '') {
        this.loading = false;
        return;
      }
      this.cancelPendingRequests();
      this.loading = true;
      axios
        .get('/search', {
          params: {
            query: this.query
          }
        })
        .then((res) => {
          this.results = res.data;
          for (let i = 0; i < this.results.length; i++) {
            this.results[i].label = {
              title: this.results[i].label_title,
              color: this.results[i].label_color
            }
          }
          this.loading = false;
        }).catch(error => {
          this.loading = false;
          return error;
        });
    },
    resetQuery() {
      this.query = '';
    }
  }
}
</script>

<style lang="scss" scoped>
@import "../../stylesheets/variables.scss";
@import "../../stylesheets/extend.scss";

.loading-case {
  width: 100%;
  height: 200px;
}

.sidebar-right {
  width: 250px;
  margin-left: 30px;

  &__inner {
    @extend %sidebar-display;
  }

  &__search,
  &__calendar {
    margin-bottom: 20px;
  }
}

.search {
  position: relative;

  &__form {
    box-shadow: $box-shadow-common;
    display: flex;
    align-items: center;
  }

  &__input {
    width: 100%;
    height: 34px;
    border: none;
    border-radius: 4px;
    background-color: #fff;
    box-shadow: inset 0 0 2px #ccc;
    padding-left: 32px;
    padding-right: 35px;
    appearance: textfield;
  }

  &__lense {
    position: absolute;
    left: 10px;
    color: #aaa;
  }

  &__reset {
    position: absolute;
    color: #aaa;
    right: 10px;
    margin: auto;
    cursor: pointer;
  }

  &__box {
    list-style-type: none;
    padding-left: 0;
    margin: 0;
    overflow-y: scroll;
    height: calc(100vh - 195px);
    padding: 0 15px;
    margin: 0 -15px;
  }

  &__date {
    font-size: 0.7em;
    margin-top: 0.8em;
    margin-bottom: 0.15em;
    color: #999;
  }

  &__list {
    box-shadow: $box-shadow-common;
  }

  &__item {
    padding: 12px;
    background-color: #ffffff;
    border-bottom: 1px solid #e8e8e8;
    font-size: 0.8em;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    cursor: pointer;

    .label {
      margin: 0 0 0 8px;
      font-size: 10px;
      padding: 4px 7px;
    }
  }

  &__no-result {
    text-align: center;
    margin-top:100px;
  }
}
</style>
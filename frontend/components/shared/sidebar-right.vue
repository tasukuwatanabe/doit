<template>
  <aside v-if="isTodo" class="sidebar sidebar-right">
    <div class="sidebar--stickey sidebar-right__inner">
      <SidebarShortcut class="display--sp" />
      <section class="sidebar-right__search search">
        <div class="search__form">
          <i class="fa fa-search search__lense"></i>
          <input type="text" class="search__input" v-model="query" @keyup="todoSearch" placeholder="Todoを検索" />
          <div v-if="query" class="search__reset" @click="resetQuery">
            <i class="fas fa-times-circle"></i>
          </div>
        </div>
        <div v-if="query" class="search__box">
          <Loading v-if="loading" />
          <template v-else>
            <template v-if="results.length">
              <div v-for="resultDate in resultDateArray" :key="resultDate">
                <div class="search__date">
                    {{ resultFormatDate(resultDate) }}
                </div>
                <div class="search__list">
                  <div v-for="result in todoByDate(resultDate)"
                      @click="fetchDate(result.todo_date)" :key="result.id"
                      class="search__item">
                    <div :class="[ result.label_title ? 'search__title--with-label' : '' ]">
                      {{ result.title }}
                    </div>
                    <LabelItem :target-item="result" v-if="result.label_color" />
                  </div>
                </div>
              </div>
            </template>
            <div v-else class="search__no-result">結果なし</div>
          </template>
        </div>
      </section>
      <template v-if="!query">
        <SidebarCalendar />
        <SidebarShortcut class="display--pc" />
      </template>
    </div>
  </aside>
</template>

<script>
import axios from "axios";
import moment from "../../modules/myMoment";
import { mapGetters, mapActions } from "vuex";
import SidebarCalendar from "./sidebar-calendar";
import SidebarShortcut from "./sidebar-shortcut";
import LabelItem from "../label-item";
import Loading from "./loading";

export default {
  data() {
    return {
      query: '',
      results: [],
      loading: ''
    }
  },
  components: {
    SidebarCalendar,
    SidebarShortcut,
    LabelItem,
    Loading
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
      if (this.query.length === 0) {
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
@import "../../stylesheets/mixin.scss";

.loading-case {
  width: 100%;
  height: 200px;
  @include loadingCase($width: 100%,
                        $spWidth:100%,
                        $height: 200px,
                        $spHeight:200px)
}

.sidebar-right {
  width: 250px;
  @media (max-width: 991px) {
    width: 100%;
  }

  &__search,
  &__calendar {
    margin-bottom: 20px;

    @media (max-width: 991px) {
      margin-bottom: 30px;
    }
  }
}

.display {
  &--pc {
    display: block;
    @media (max-width: 991px) {
      display: none;
    }
  }

  &--sp {
    display: none;

    @media (max-width: 991px) {
      display: block;
    }
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
    height: 38px;
    border: none;
    border-radius: 4px;
    background-color: #fff;
    box-shadow: inset 0 0 2px #ccc;
    padding-left: 38px;
    padding-right: 35px;
    appearance: textfield;

    @media (max-width: 991px) {
      height: 45px;
    }
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
    margin: 20px -15px 0;
    @media (max-width: 991px) {
      height: auto;
      max-height: 500px;
    }
  }

  &__date {
    font-size: 0.8em;
    margin-top: 0.8em;
    margin-bottom: 0.15em;
    color: #999;

    @media (max-width: 991px) {
      font-size: 0.9em;
    }
  }

  &__list {
    box-shadow: $box-shadow-common;
  }

  &__item {
    padding: 12px;
    background-color: #ffffff;
    border-bottom: 1px solid #e8e8e8;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    cursor: pointer;

    @media (min-width: 992px) {
      font-size: 0.8em;
    }

    .label {
      margin: 0 0 0 8px;
      font-size: 10px;
      padding: 4px 7px;
    }
  }

  &__title {
    &--with-label {
      margin-right: 10px;
    }
  }

  &__no-result {
    text-align: center;
    margin-top:100px;
  }
}
</style>
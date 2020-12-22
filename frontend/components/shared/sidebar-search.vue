<template>
  <section class="sidebar-right__search">
    <div class="search__form">
      <i class="fa fa-search search__lense"></i>
      <input type="text" class="search__input" v-model="searchQuery" @keyup="todoSearch(); sendSearchStatus()" placeholder="Todoを検索" />
      <div v-if="searchQuery" class="search__reset" @click="resetSearchQuery">
        <i class="fas fa-times-circle"></i>
      </div>
    </div>
    <div v-if="searchQuery" class="search__box">
      <Loading v-if="loading" />
      <template v-else>
        <template v-if="searchResults.length">
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
</template>

<script>
import axios from "axios";
import moment from "../../modules/myMoment";
import Loading from "./loading";
import LabelItem from "../label-item";
import { mapActions } from "vuex";

export default {
  data() {
    return {
      searchResults: [],
      searchQuery: '',
      loading: ''
    }
  },
  components: {
    Loading,
    LabelItem
  },
  computed: {
    resultDateArray() {
      let resultDates = [];
      for (let i = 0; i < this.searchResults.length; i++) {
        if (i === 0 || !resultDates.includes(this.searchResults[i].todo_date)) {
          resultDates.push(this.searchResults[i].todo_date);
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
      return function(date) {
        return this.searchResults.filter(result => result.todo_date === date);
      }
    }
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction",
      cancelPendingRequests: "request/cancelPendingRequests"
    }),
    sendSearchStatus() {
      this.$emit("search-status", this.searchQuery);
    },
    fetchDate(todo_date) {
      this.setSelectedDateAction(todo_date);
    },
    todoSearch() {
      if (this.searchQuery.length === 0) {
        this.loading = false;
        return;
      }
      this.cancelPendingRequests();
      this.loading = true;
      axios
        .get('/search', {
          params: {
            search_query: this.searchQuery
          }
        })
        .then((res) => {
          this.searchResults = res.data;
          this.loading = false;
        }).catch(error => {
          this.loading = false;
          return error;
        });
    },
    resetSearchQuery() {
      this.searchQuery = '';
    }
  }
}
</script>

<style lang="scss" scoped>
@import "../../stylesheets/variables.scss";
@import "../../stylesheets/mixin.scss";

.loading-case {
  @include loadingCase($width: 100%,
                        $spWidth:100%,
                        $height: 220px,
                        $spHeight:200px)
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
    height: calc(100vh - 300px);
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
    
    @media (max-width: 991px) {
      margin: 80px 0;
    }
  }
}
</style>
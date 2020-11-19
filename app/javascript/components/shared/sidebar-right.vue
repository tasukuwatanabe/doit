<template>
  <aside v-if="this.getCurrentUser && is_todo" class="sidebar">
    <div class="sidebar__stickey-part sidebar-right">
      <section class="sidebar-right__search search">
        <div class="search__form">
          <span class="fa fa-search"></span>
          <input type="text" class="search__input" v-model="query" @keyup="todoSearch(query)" />
        </div>
      </section>
      <div v-if="query">
        <div v-if="result && result.length" class="search__list">
          <div v-for="(todo, index) in result" :key="todo.id">
            <div class="search__date" v-if="checkDate(todo, index)">
              {{ setSelectedDate(todo.todo_date) }}
            </div>
            <div @click="fetchDate(todo.todo_date)" class="search__item">{{ todo.title }}
              <div
                class="label"
                v-if="todoLabel(todo)"
                :style="{
                  color: colorOnRgb(todoLabel(todo).color),
                  backgroundColor: todoLabel(todo).color
                }">
                {{ todoLabel(todo).title }}
              </div>
            </div>
          </div>
        </div>
        <div v-else class="search__no-result">結果なし</div>
      </div>
      <div v-else>
        <section class="sidebar-right__calendar">
          <div class="text-center">
            <router-link to="/" class="btn-outlined btn--xs">今日</router-link>
          </div>
          <table class="sidebar-right__calendar-table calendar-table">
            <tr>
              <th>日</th>
              <th>月</th>
              <th>火</th>
              <th>水</th>
              <th>木</th>
              <th>金</th>
              <th>土</th>
            </tr>
            <tr>
              <td class="calendar-table--out">30</td>
              <td class="calendar-table--out">31</td>
              <td>1</td>
              <td>2</td>
              <td>3</td>
              <td>4</td>
              <td>5</td>
            </tr>
            <tr>
              <td>6</td>
              <td>7</td>
              <td>8</td>
              <td>9</td>
              <td>10</td>
              <td>11</td>
              <td>12</td>
            </tr>
            <tr>
              <td>13</td>
              <td>14</td>
              <td>15</td>
              <td>16</td>
              <td>17</td>
              <td>18</td>
              <td>19</td>
            </tr>
            <tr>
              <td>20</td>
              <td>21</td>
              <td>22</td>
              <td>23</td>
              <td>24</td>
              <td>25</td>
              <td>26</td>
            </tr>
            <tr>
              <td>27</td>
              <td>28</td>
              <td class="calendar-table--active">
                <div>29</div>
              </td>
              <td>30</td>
              <td>31</td>
              <td class="calendar-table--out">1</td>
              <td class="calendar-table--out">2</td>
            </tr>
          </table>
        </section>
        <section class="sidebar-right__detail">
          <div class="detail__title">読書をする</div>
          <ul class="detail__list">
            <li class="detail__item">
              <span class="label detail__label">自己投資</span>
            </li>
            <li class="detail__item">
              <span>2020年10月28日</span>
            </li>
            <li class="detail__item">
              <span>「嫌われる勇気」を10ページ読む</span>
            </li>
          </ul>
        </section>
      </div>
    </div>
  </aside>
</template>

<script>
import axios from "axios";
import { mapGetters, mapActions } from "vuex";
import ColorOnRgb from "../mixins/color-on-rgb";

export default {
  data() {
    return {
      query: '',
      result: [],
      labels: [],
      todo_date: '',
      not_found: ''
    }
  },
  computed: {
    ...mapGetters({
      getCurrentUser: "user/getCurrentUser",
    }),
    checkDate() {
      return function(todo, index) {
        if (index > 0) {
          return todo.todo_date !== this.result[index - 1].todo_date;
        } else {
          return true;
        }
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
      axios
        .get('/api/search', {
          params: {
            query: this.query
          }
        })
        .then((res) => {
          this.result = res.data.todos;
          this.labels = res.data.labels;
        });
    }
  }
}
</script>
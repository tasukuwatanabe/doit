<template>
  <aside v-if="root" class="sidebar-right">
    <section class="sidebar-right__search search">
      <form action="" class="search__form">
        <span class="fa fa-search"></span>
        <input type="text" class="search__input" />
        <ul></ul>
      </form>
    </section>

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
  </aside>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      todos: [],
      todo: {}
    };
  },
  computed: {
    root() {
      return this.$route.path === "/";
    }
  }
};
</script>

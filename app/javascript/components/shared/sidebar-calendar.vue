<template>
  <section class="sidebar-right__calendar calendar">
    <div class="calendar__box">
      <div class="calendar__control">
        <div @click="goPrevMonth" class="calendar__controlBtn">
          <i class="fas fa-caret-left"></i>
        </div>
        <div>{{ yearMonth }}</div>
        <div @click="goNextMonth" class="calendar__controlBtn">
          <i class="fas fa-caret-right"></i>
        </div>
      </div>
      <table class="calendar__table">
        <tr>
          <th v-for="week in this.weeks" :key="week">{{ week }}</th>
        </tr>
        <template v-for="(week, index) in calendarData">
          <tr :key="index">
            <template v-for="(date, index) in week">
              <td @click="fetchDate(week, date)"
                :key="index"
                :class="calendarClass(week, date)"
                class="calendar__date">{{ date }}</td>
            </template>
          </tr>
        </template>
      </table>
      <div class="calendar__back">
        <div @click="fetchToday" class="calendar__backBtn">今日へ戻る</div>
      </div>
    </div>
  </section>
</template>

<script>
import moment from "moment";
import { mapGetters, mapActions } from "vuex";

export default {
  data() {
    return {
      weeks: ['日', '月', '火', '水', '木', '金', '土'],
      current: 0,
      judgeMonth: ''
    }
  },
  computed: {
    ...mapGetters({
      getSelectedDate: "date/getSelectedDate"
    }),
    calendarClass() {
      return function(week, date) {

        let classCase;

        // 選択された日付のyear
        const selectedYear = this.currentMoment.year();
        // 選択された日付のmonth
        const selectedMonth = this.currentMoment.month() + 1;
        // 選択された日付のdate
        const selectedDate = date;

        // 表示中の月外の日付かどうかを判別
        const outOfMonth = week === this.calendarData[0] && date >= 21 ||
                            week === this.calendarData[this.calendarData.length - 1] && date <= 10
        
        // カレンダーから今日の日付を判別
        const isToday = selectedYear === moment().year() &&
                        selectedMonth === moment().month() + 1 &&
                        selectedDate === moment().date()

        // カレンダーから選択中の日付を判別
        const isSelected = selectedYear === this.getSelectedDate.getFullYear() &&
                            selectedMonth === this.getSelectedDate.getMonth() + 1 &&
                            date === this.getSelectedDate.getDate() &&
                           !outOfMonth // 月外なら除外する

        if (outOfMonth) {
          classCase = 'calendar__date--out'; // 月外の場合のクラス
        } else if (isToday) {
          classCase += ' calendar__date--today'; // 今日の場合のクラス
        } else if(isSelected) {
          classCase += ' calendar__date--selected'; // 選択中の場合のクラス
        }

        return classCase;
      }
    },
    currentMoment() {
      // 今月を取得
      return moment().add(this.current, 'months');
    },
    yearMonth() {
      // 今月の表示をYYYY年MM月に変換
      return this.currentMoment.format('YYYY年M月');
    },
    calendarData() {
      // 今月の終了日を取得
      const numOfMonth = this.currentMoment.endOf('month').date();

      // 先月の終了日を取得
      const numOfLastMonth = moment().add(this.current - 1, 'months').endOf('month').date();

      // 今月の開始日から終了日までを配列に格納する
      const daysOfMonth = [...Array(numOfMonth).keys()].map(i => ++i);

      // 今月の開始曜日を取得
      const firstWeekDay = this.currentMoment.startOf('month').weekday()

      const data = [...Array(6)].map((empty, weekIndex) => 
        [...Array(7)].map((empty, dayIndex) => {
          const i = 7 * weekIndex + dayIndex - firstWeekDay;
          if (i > 0 && daysOfMonth[i] === undefined) {
            return daysOfMonth[i - numOfMonth];
          } else if (i < 0) {
            return numOfLastMonth + 1 + i;
          }
          return daysOfMonth[i];
        })
      );

      if (!data[5].includes(numOfMonth)) {
        data.pop();
      }

      return data;
    }
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: "date/setSelectedDateAction"
    }),
    goNextMonth() {
      this.current++;
    },
    goPrevMonth() {
      this.current--;
    },
    fetchDate(week, date) {
      if (week === this.calendarData[0] && date >= 21) {
        this.current--; // 前月の日付であれば、ひと月分戻す
      } else if (week === this.calendarData[this.calendarData.length - 1] && date <= 10) {
        this.current++; // 翌月の日付であれば、ひと月分進める
      }
      const year = this.currentMoment.year(); // 表示するyearを取得
      const month = this.currentMoment.month() + 1; // 表示するmonthを取得
      const selectedDate = `${year}-${month}-${date}`;
      this.setSelectedDateAction(selectedDate);
    },
    fetchToday() {
      this.current = 0;
      const selectedDate = moment().format('YYYY-MM-DD');
      this.setSelectedDateAction(moment());
    }
  }
}
</script>
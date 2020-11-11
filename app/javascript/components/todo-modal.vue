<template>
  <div class="modal" :class="{ 'is-open': modalActive }">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent novalidate="true" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal">
              <i class="fas fa-times"></i>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">タイトル</div>
              </div>
              <div class="col-9">
                <input
                  type="text"
                  class="form__input"
                  v-model="todo.title"
                  required
                />
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">ラベル</div>
              </div>
              <div class="col-9">
                <select v-model="todo.label_id" class="form__select">
                  <option>ラベルを選択</option>
                  <option
                    v-for="label in labels"
                    :key="label.id"
                    :value="label.id"
                  >
                    {{ label.title }}
                  </option>
                </select>
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">開始日</div>
              </div>
              <div class="col-9">
                <input
                  type="date"
                  v-model="todo.start_date"
                  class="form__input"
                />
              </div>
            </div>
            <div class="form__group row form__group--end-day">
              <div class="col-3">
                <div class="form__label">終了日</div>
              </div>
              <div class="col-9">
                <input
                  type="date"
                  v-model="todo.end_date"
                  class="form__input"
                  :readonly="todo.continue_without_end"
                />
                <div class="checkbox-with-text">
                  <input
                    type="checkbox"
                    name="continue_without_end"
                    id="continue_without_end"
                    v-model="todo.continue_without_end"
                  />
                  <label for="continue_without_end"
                    >終了日を設定せず繰り返す</label
                  >
                </div>
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">曜日指定</div>
              </div>
              <div class="col-9">
                <div class="day-check">
                  <label v-for="n in 7" class="day-check__label" :key="n - 1">
                    <input
                      type="checkbox"
                      v-model="todo.apply_days"
                      :value="n - 1"
                      class="day-check__input"
                      multiple
                    />
                    <span>{{ weeks[n - 1] }}</span>
                  </label>
                </div>
              </div>
            </div>
            <div class="form__group row">
              <div class="col-3">
                <div class="form__label">メモ</div>
              </div>
              <div class="col-9">
                <input type="text" class="form__input" v-model="todo.body" />
              </div>
            </div>
            <!-- <div class="form__group row">
                    <div class="col-3">
                      <div class="form__label">達成度を表示</div>
                    </div>
                    <div class="col-9">
                      <div class="btn-slide">
                        <input
                          type="checkbox"
                          name="history_display"
                          id="history_display"
                          class="btn-slide__input"
                          v-model="todo.history_display"
                        />
                        <label
                          for="history_display"
                          class="btn-slide__label"
                        ></label>
                      </div>
                    </div>
                  </div> -->
            <div class="btn-case">
              <div @click="toggleModal" class="btn-gray btn--sm">
                キャンセル
              </div>
              <div @click="todoSubmit" class="btn-main btn--sm">
                {{ btnText }}
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapActions } from "vuex";
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  data() {
    return {
      labels: [],
      todo: {
        id: undefined,
        title: undefined,
        label_id: undefined,
        start_date: undefined,
        end_date: undefined,
        apply_days: undefined,
        continue_without_end: undefined,
        body: undefined
      },
      weeks: ["日", "月", "火", "水", "木", "金", "土"],
      btnText: ""
    };
  },
  created() {
    this.fetchLabels();
  },
  computed: {
    ...mapGetters(["selectedDate", "formatDate"])
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    fetchLabels() {
      axios.get("/api/labels").then((res) => {
        this.labels = res.data.labels;
      });
    },
    setTodoValue(val) {
      this.toggleModal();
      this.todo.id = val.id;
      this.todo.title = val.title;
      this.todo.label_id = val.label_id;
      this.todo.start_date = val.start_date || this.formatDate;
      this.todo.end_date = val.end_date || this.formatDate;
      this.todo.apply_days = val.apply_days || [...Array(7).keys()];
      this.todo.continue_without_end = val.continue_without_end;
      this.todo.body = val.body;
      this.btnText = val.title ? "更新する" : "新規作成";
    },
    async todoSubmit() {
      const todo_id = this.todo.id;
      const todo_params = {
        title: this.todo.title,
        label_id: this.todo.label_id,
        start_date: this.todo.start_date,
        end_date: this.todo.end_date,
        apply_days: this.todo.apply_days,
        continue_without_end: this.todo.continue_without_end,
        body: this.todo.body
      };
      if (todo_id) {
        await axios.put(`/api/todos/${todo_id}`, { todo: todo_params });
      } else {
        await axios.post("/api/todos", { todo: todo_params });
      }
      this.toggleModal();
      this.$emit("fetch-todos", this.selectedDate);
      this.todo = {};
    }
  }
};
</script>

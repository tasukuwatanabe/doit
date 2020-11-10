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
                    <!-- <span>{{ weeks[n - 1] }}</span> -->
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
              <div @click="updateTodo(todo)" class="btn-main btn--sm">
                更新する
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Modal from "./mixins/modal";
import ColorOnRgb from "./mixins/color-on-rgb";
export default {
  data() {
    return {
      labels: [],
      todo: {},
      btnText: ""
    };
  },
  mixins: [Modal, ColorOnRgb],
  methods: {
    setTodoValue(todo) {
      this.modalActive = true;
      if (todo) {
        this.todo.title = todo.title;
        this.todo.label_id = todo.label_id;
        this.todo.start_date = todo.start_date;
        this.todo.end_date = todo.end_date;
        this.todo.continue_without_end = todo.continue_without_end;
        this.todo.apply_days = todo.apply_days;
        this.todo.body = todo.body;
      }
      this.btnText = todo ? "更新する" : "新規作成";
    },
    async todoSubmit(label) {
      this.todo.color = this.colorPicker.hex;
      if (todo) {
        await axios.put(`/api/todos/${this.todo.id}`, {
          params: { todo: this.todo }
        });
      } else {
        await axios.post("/api/todos", { params: { todo: this.todo } });
      }
      this.todo = {};
      this.modalActive = false;
      this.$emit("fetch-todos");
    }
  }
};
</script>

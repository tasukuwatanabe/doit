<template>
  <div class="modal" v-if="modalActive">
    <div class="modal__layer">
      <div class="modal__box">
        <form @submit.prevent="shortcutSubmit" class="form">
          <div class="modal-form">
            <div class="fa-case" @click="toggleModal">
              <i class="fas fa-times"></i>
            </div>
            <div>
              <div class="form__group row">
                <div class="col-3">
                  <div
                    class="form__label"
                    :class="{ 'form__label--with-error': errors.title }"
                  >
                    タイトル<span class="form__label--required">*</span>
                  </div>
                </div>
                <div class="col-9">
                  <input
                    type="text"
                    v-model="shortcut.title"
                    class="form__input"
                  />
                  <span class="form__error" v-if="errors.title">
                    {{ errors.title }}
                  </span>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3 form__label">ラベル</div>
                <div class="col-9">
                  <select class="form__select" v-model="shortcut.label_id">
                    <option :value="null">ラベルを選択</option>
                    <option
                      v-for="label in labels"
                      :key="label.id"
                      :value="label.id"
                    >
                      {{ label.label_title }}
                    </option>
                  </select>
                </div>
              </div>
              <div class="btn-case">
                <div @click="toggleModal" class="btn btn--gray btn--sm">
                  キャンセル
                </div>
                <button type="submit" class="btn btn--blue btn--sm">
                  {{ btnText }}
                </button>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { axiosForBackend } from "../config/axios";
import Modal from "./mixins/modal";

export default {
  name: "ShortcutModal",
  data() {
    return {
      shortcut: {},
      labels: [],
      btnText: "",
    };
  },
  created() {
    this.fetchLabels();
  },
  mixins: [Modal],
  methods: {
    fetchLabels() {
      axiosForBackend
        .get("/labels")
        .then((res) => {
          this.labels = res.data;
        })
        .catch(error => {
          return error;
        });
    },
    setShortcutValue(val) {
      this.toggleModal();
      this.shortcut.id = val.id;
      this.shortcut.title = val.title;
      this.shortcut.label_id = val.label_id;
      this.btnText = val.id ? "更新する" : "新規作成";
    },
    shortcutSubmit() {
      if (this.shortcut.id) {
        axiosForBackend
          .put(`/shortcuts/${this.shortcut.id}`, {
            shortcut: {
              title: this.shortcut.title,
              label_ids: [this.shortcut.label_id]
            }
          })
          .then(() => {
            this.shortcut = {};
            this.toggleModal();
            this.$emit("fetch-shortcuts");
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      } else {
        axiosForBackend
          .post("/shortcuts", {
            shortcut: {
              title: this.shortcut.title,
              label_ids: [this.shortcut.label_id]
            }
          })
          .then(() => {
            this.shortcut = {};
            this.toggleModal();
            this.$emit("fetch-shortcuts");
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      }
    }
  }
};
</script>
<template>
  <div id="app">
    <ul class="todo__list">
      <li class="todo__item" v-for="s in shortcuts" :key="s.id">
        <div class="todo__item-title">
          {{ s.title }}
        </div>
        <div class="todo__item-link-box">
          <b-button
            v-on:click="deleteShortcut(s.id)"
            pill
            variant="outline-danger"
            >削除</b-button
          >
        </div>
      </li>
    </ul>
    <div class="modal-trigger">
      <button class="float-right btn btn-info btn-sm" v-on:click="openModal">
        ショートカットを追加
      </button>
    </div>
    <div class="modal" :class="{ 'is-open': isModalActive }">
      <div class="modal__layer" @click.self="closeModal">
        <div class="modal__box">
          <form @submit.prevent novalidate="true">
            <div class="modal-form">
              <div class="fa-case" @click="closeModal">
                <i class="fas fa-times"></i>
              </div>
              <input
                type="text"
                placeholder="タイトル"
                class="form-control"
                v-model="shortcut.title"
                required
                @keydown:enter="createShortcut"
              />
              <ul v-if="errors.length" class="error-list" style="color: red;">
                <li v-for="(error, index) in errors" :key="`error-${index}`">
                  {{ error }}
                </li>
              </ul>
              <div class="btn-case">
                <div
                  @click="closeModal"
                  class="btn-cancel btn btn-sm btn-outline-info"
                >
                  キャンセル
                </div>
                <button @click="createShortcut" class="btn btn-sm btn-info">
                  新規作成
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "ShortcutHome",
  data() {
    return {
      isModalActive: false,
      shortcuts: [],
      shortcut: {
        title: ""
      },
      errors: []
    };
  },
  mounted() {
    this.fetchShortcuts();
  },
  methods: {
    fetchShortcuts() {
      axios.get("/api/shortcuts.json").then(
        (response) => {
          this.shortcuts = response.data;
        },
        (error) => {
          console.log(error);
        }
      );
    },
    setShortcutTitle(id) {
      axios.get("/api/shortcuts").then(
        (res) => {
          for (let i = 0; i < res.data.shortcuts.length; i++) {
            this.shortcuts.push(res.data.shortcuts[i]);
          }
        },
        (error) => {
          console.log(error);
        }
      );
    },
    createShortcut(e) {
      this.errors = [];
      if (!this.shortcut.title) {
        this.errors.push("タイトルは必須です");
        return;
      }
      axios.post("/api/shortcuts/", { shortcut: this.shortcut }).then(
        (res) => {
          this.shortcut.title = "";
          this.fetchShortcuts();
          this.closeModal();
        },
        (error) => {
          this.errors.push("タイトルが重複しています");
        }
      );
    },
    deleteShortcut(id) {
      axios.delete(`/api/shortcuts/${id}`).then((res) => {
        this.fetchShortcuts();
      });
    },
    openModal() {
      this.isModalActive = true;
    },
    closeModal() {
      this.isModalActive = false;
      this.errors = [];
    }
  }
};
</script>

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
      <form v-on:submit.prevent="createShortcut" novalidate="true">
        <div class="form-group row">
          <div class="col-sm-8">
            <input
              type="text"
              placeholder="タイトル"
              class="form-control"
              v-model="shortcut.title"
              required
            />
            <p v-if="errors.length" class="error" style="color: red;">
              <ul>
                <li v-for="(error, index) in errors" :key="`error-${index}`">{{ error }}</li>
              </ul>
            </p>
          </div>
          <div class="col-sm-4">
            <button class="btn btn-info">
              ショートカットを作成
            </button>
          </div>
        </div>
      </form>
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
      if(!this.shortcut.title) {
        this.errors.push("タイトルは必須です");
        return
      }
      axios.post("/api/shortcuts/", { shortcut: this.shortcut }).then(
        (res) => {
          this.fetchShortcuts();
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
      this.toggleModal();
    },
    toggleModal() {
      this.isModalActive = !this.isModalActive;
    },
  }
};
</script>

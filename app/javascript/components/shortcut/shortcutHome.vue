<template>
  <div class="shortcut">
    <div class="headline">
      <div class="headline__title">
        ショートカットの管理
        <span class="icon headline__icon">
          <svg width="20px" height="20px">
            <g
              transform="translate(10.000000, 10.000000) scale(-1, 1) translate(-10.000000, -10.000000)"
            >
              <path
                d="M7.85447699,4.30359833 L7.85447699,0.713891213 C7.85435146,0.319497908 7.53456067,-3.6959034e-08 7.14016736,-3.6959034e-08 C6.93790795,-3.6959034e-08 6.74518828,0.0858995816 6.60979079,0.236150628 L0.183054393,7.37702929 C-0.0519665272,7.63878661 -0.0613807531,8.03267782 0.160920502,8.30535565 L6.58769874,16.1602929 C6.83740586,16.465523 7.28728033,16.5105439 7.5925523,16.2608368 C7.75790795,16.1255649 7.85401674,15.9233473 7.85447699,15.7097071 L7.85447699,12.1514226 C13.4957741,12.3349372 17.0161925,14.7464017 18.6029289,19.5065272 C18.700251,19.7977406 18.9728452,19.9942296 19.2798745,19.9942296 C19.3183682,19.9942296 19.3568619,19.9912134 19.3948536,19.9849372 C19.7402929,19.9285774 19.9939749,19.6301674 19.9939749,19.2801255 C19.9939749,10.871046 14.9317992,4.6934728 7.85447699,4.30359833 Z"
              ></path>
            </g>
          </svg>
        </span>
      </div>
      <p class="headline__text">
        使用頻度の高いToDoをショートカットとして登録できます。
      </p>
      <div class="page-action headline__page-action">
        <a v-on:click="openModal" class="page-action__btn btn-outlined btn--sm">
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text">新規追加</span>
        </a>
      </div>
    </div>
    <ul class="list" v-if="shortcuts.length">
      <li class="list__item" v-for="s in shortcuts" :key="s.id">
        <div class="list__block list__block--left">
          <div class="list__title-group" style="position: relative;">
            <div
              v-show="s.id != editingShortcutId"
              @dblclick="editShortcut(s)"
              class="list__title"
            >
              {{ s.title }}
            </div>
            <div>
              <input
                v-show="s.id == editingShortcutId"
                v-model="s.title"
                v-focus
                @keyup.enter="updateShortcut(s)"
              />
              <span
                @click="fetchShortcuts"
                v-if="
                  !s.title.length ||
                    (errors.length && s.id == editingShortcutId)
                "
                >×リセット</span
              >
            </div>
            <span
              v-if="!s.title.length"
              style="color: red; font-size: 12px; position: absolute;"
              >タイトルが未入力です</span
            >
            <span
              v-else-if="errors.length && s.id == editingShortcutId"
              style="color: red; font-size: 12px; position: absolute;"
              >{{ errors[0] }}</span
            >
          </div>
        </div>
        <div class="list__block list__block--right list__block--grow">
          <div class="label label--margin">プログラミング</div>
          <div class="item-action">
            <a v-on:click="editShortcut(s.id)" class="item-action__btn">
              <i class="fas fa-pencil-alt"></i>
            </a>
            <a v-on:click="deleteShortcut(s.id)" class="item-action__btn">
              <i class="fas fa-trash"></i>
            </a>
          </div>
        </div>
      </li>
    </ul>
    <div class="no-result no-result" v-else>
      <div class="no-result__illustration">
        <img
          src="/illustrations/il-navigation.png"
          alt="チェックリストのイラスト"
        />
      </div>
    </div>
    <div class="modal" :class="{ 'is-open': isModalActive }">
      <div class="modal__layer" @click.self="closeModal">
        <div class="modal__box">
          <form @submit.prevent novalidate="true" class="form">
            <div class="modal-form">
              <div class="fa-case" @click="closeModal">
                <i class="fas fa-times"></i>
              </div>
              <div class="form__group row">
                <div class="col-3 form__label">
                  タイトル
                </div>
                <div class="col-9">
                  <input
                    type="text"
                    class="form__input"
                    v-model="shortcut.title"
                    required
                    @keydown:enter="createShortcut"
                  />
                  <div v-if="errors.length">{{ errors[0] }}</div>
                </div>
              </div>
              <div class="form__group row">
                <div class="col-3 form__label">
                  ラベル
                </div>
                <div class="col-9">
                  <select name="label" class="form__select">
                    <option value="" class="first" selected disabled
                      >ラベルを選択</option
                    >
                    <option value="プログラミング">プログラミング</option>
                    <option value="育児">育児</option>
                    <option value="スポーツ">スポーツ</option>
                  </select>
                </div>
              </div>
              <div class="btn-case">
                <div @click="closeModal" class="btn-gray btn--sm">
                  キャンセル
                </div>
                <div @click="createShortcut" class="btn-main btn--sm">
                  新規作成
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import axios from "axios";

Vue.directive("focus", {
  update(el) {
    Vue.nextTick(function() {
      el.focus();
    });
  }
});

export default {
  name: "shortcutHome",
  data() {
    return {
      isModalActive: false,
      shortcuts: [],
      shortcut: {
        title: ""
      },
      errors: [],
      editingShortcutId: null,
      editedShortcut: null
    };
  },
  mounted() {
    this.fetchShortcuts();
  },
  methods: {
    fetchShortcuts() {
      this.errors = [];
      this.editedShortcut = null;
      this.editingShortcutId = null;
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
    editShortcut(shortcut) {
      this.fetchShortcuts();
      this.editingShortcutId = shortcut.id;
    },
    updateShortcut(shortcut) {
      this.errors = [];
      if (!shortcut.title) {
        return;
      }
      this.editedShortcut = shortcut;
      axios
        .put(`/api/shortcuts/${shortcut.id}`, { shortcut: this.editedShortcut })
        .then(
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
      this.isModalActive = true;
    },
    closeModal() {
      this.isModalActive = false;
      this.errors = [];
    }
  }
};
</script>

<style scoped>
.error-list {
  list-style-type: none;
  font-size: 12px;
  padding-left: 0;
  margin-top: 5px;
  margin-bottom: 10px;
}
</style>

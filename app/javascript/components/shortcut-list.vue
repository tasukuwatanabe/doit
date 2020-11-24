<template>
  <div class="shortcut content">
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
        <a
          @click="setShortcut()"
          class="page-action__btn btn-outlined btn--sm"
        >
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text">新規追加</span>
        </a>
      </div>
    </div>
    <v-loading-icon v-show="loading"></v-loading-icon>
    <div v-show="!loading">
      <ul class="list" v-if="shortcuts.length">
        <li
          class="list__item"
          v-for="shortcut in shortcuts"
          :key="shortcut.id"
        >
          <div class="list__block list__block--left">
            <div class="list__title-group" style="position: relative">
              <div class="list__title">
                {{ shortcut.shortcut_title }}
              </div>
            </div>
          </div>
          <div class="list__block list__block--right list__block--grow">
            <div
              class="label label--margin"
              v-if="shortcut.label_color"
              :style="{
                color: colorOnRgb(shortcut.label_color),
                backgroundColor: shortcut.label_color
              }"
            >
              {{ shortcut.label_title }}
            </div>
            <div v-else></div>
            <div class="item-action">
              <a @click="setShortcut(shortcut)" class="item-action__btn">
                <i class="fas fa-pencil-alt"></i>
              </a>
              <a @click="deleteShortcut(shortcut)" class="item-action__btn">
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
    </div>
    <shortcut-modal
      @fetch-shortcuts="fetchShortcuts"
      ref="shortcutModal"
    ></shortcut-modal>
  </div>
</template>

<script>
import axios from "axios";
import ShortcutModal from "./shortcut-modal.vue";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  name: "Shortcut",
  components: {
    "shortcut-modal": ShortcutModal
  },
  data() {
    return {
      shortcuts: [],
      loading: ''
    };
  },
  created() {
    this.loading = true;
    this.fetchShortcuts();
  },
  mixins: [ColorOnRgb],
  methods: {
    fetchShortcuts() {
      axios
        .get("/api/shortcuts")
        .then((res) => {
          this.shortcuts = res.data;
          this.loading = false;
        })
        .catch(error => {
          console.log("通信がキャンセルされました");
          this.loading = false;
        });
    },
    setShortcut(shortcut) {
      if (this.shortcuts.length >= 10 && !shortcut) {
        this.flashMessage.error({
          title: "ショートカットが登録できるのは10個までです",
          icon: '/flash/error.svg',
        });
      } else {
        this.$refs.shortcutModal.setShortcutValue(shortcut);
      }
    },
    deleteShortcut(shortcut) {
      axios.delete(`/api/shortcuts/${shortcut.shortcut_id}`)
            .then(() => {
              this.fetchShortcuts();
            });
    }
  }
};
</script>

<style scoped>
.loading-case {
  width: 600px;
  height: 350px;
}
</style>
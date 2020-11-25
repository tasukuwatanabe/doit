<template>
  <div class="content">
    <div class="headline">
      <div class="headline__title">
        ラベルの管理
        <span class="icon headline__icon">
          <i class="fas fa-tag"></i>
        </span>
      </div>
      <p class="headline__text">
        ラベルを追加することでToDoを分類することができます。
      </p>
      <div class="page-action headline__page-action">
        <a
          @click="setLabel()"
          class="page-action__btn btn-outlined btn--sm"
        >
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text modal-trigger">新規追加</span>
        </a>
      </div>
    </div>
    <v-loading-icon v-show="loading"></v-loading-icon>
    <div v-show="!loading">
      <ul class="list" v-if="labels.length">
        <li class="list__item" v-for="label in labels" :key="label.id">
          <div class="list__block list__block--left">
            <div
              class="label label--margin"
              :style="{
                color: colorOnRgb(label.color),
                backgroundColor: label.color
              }"
            >
              {{ label.title }}
            </div>
          </div>
          <div class="list__block list__block--right">
            <div class="label-in-use">
              {{ label.todo_count }}個のToDoで使用中
            </div>
            <div class="item-action">
              <a @click="setLabel(label)" class="item-action__btn">
                <i class="fas fa-pencil-alt"></i>
              </a>
              <a @click="deleteLabel(label)" class="item-action__btn">
                <i class="fas fa-trash"></i>
              </a>
            </div>
          </div>
        </li>
      </ul>
      <div class="no-result no-result" v-else>
        <div class="no-result__illustration">
          <img src="/illustrations/il-mindmap.png" alt="目標達成のイラスト" />
        </div>
      </div>
    </div>
    <label-modal @fetch-labels="fetchLabels" ref="labelModal"></label-modal>
  </div>
</template>

<script>
import axios from "axios";
import LabelModal from "./label-modal.vue";
import ColorOnRgb from "./mixins/color-on-rgb";

export default {
  name: "LabelList",
  components: {
    "label-modal": LabelModal
  },
  data() {
    return {
      labels: [],
      loading: ''
    };
  },
  created() {
    this.loading = true;
    this.fetchLabels();
  },
  mixins: [ColorOnRgb],
  methods: {
    fetchLabels() {
      axios
        .get("/api/labels")
        .then((res) => {
          this.labels = res.data;
          this.loading = false;
        })
        .catch(error => {
          console.log("通信がキャンセルされました");
          this.loading = false;
        });
    },
    setLabel(label) {
      if (this.labels.length >= 10 && !label) {
        this.flashMessage.error({
          title: "ラベルが登録できるのは10個までです",
          icon: '/flash/error.svg',
        });
      } else {
        this.$refs.labelModal.setLabelValue(label);
      }
    },
    deleteLabel(label) {
      axios.delete(`/api/labels/${label.id}`)
            .then(() => {
              this.fetchLabels();
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
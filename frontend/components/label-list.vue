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
          @click="setLabel"
          class="page-action__btn btn btn--main btn--sm"
        >
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text modal-trigger">新規追加</span>
        </a>
      </div>
    </div>
    <ul class="list" v-if="labels.length">
      <li class="list__item" v-for="label in labels" :key="label.id">
        <div class="list__block list__block--left">
          <LabelItem :target-item="label" />
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
        <img src="../images/illustrations/il-mindmap.png" alt="目標達成のイラスト" />
      </div>
    </div>
    <LabelModal @fetch-labels="fetchLabels" ref="labelModal" />
  </div>
</template>

<script>
import { axiosForBackend } from "../config/axios";
import { mapActions } from "vuex";
import LabelItem from "./label-item";
import LabelModal from "./label-modal";
import Logout from "./mixins/logout";
import Flash from "./mixins/flash";

export default {
  name: "LabelList",
  components: {
    LabelModal,
    LabelItem
  },
  data() {
    return {
      labels: []
    };
  },
  mixins: [Logout, Flash],
  created() {
    this.fetchLabels();
  },
  methods: {
    fetchLabels() {
      axiosForBackend
        .get("/labels")
        .then((res) => {
          this.labels = res.data;
        })
        .catch(error => {
          this.forceLogout(error);
        });
    },
    setLabel(label) {
      if (this.labels.length >= 10 && !label.id) {
        const message = "ラベルが登録できるのは10個までです";
        this.generateFlash('error', message);
      } else {
        this.$refs.labelModal.setLabelValue(label);
      }
    },
    deleteLabel(label) {
      axiosForBackend
        .delete(`/labels/${label.id}`)
        .then(() => {
          this.fetchLabels();
        });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "../stylesheets/mixin.scss";

.label-in-use {
  margin-left: 10px;
  margin-right: 50px;
  @media (max-width: 767px) {
    margin-right: 20px;
    font-size: 14px;
  }
  @media (max-width: 424px) {
    margin-right: 15px;
    font-size: 13px;
  }
  @media (max-width: 374px) {
    font-size: 12px;
  }
}
</style>
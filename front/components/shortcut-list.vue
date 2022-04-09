<template>
  <div class="shortcut content">
    <div class="headline">
      <div class="headline__title">
        ショートカットの管理
        <span class="icon headline__icon">
          <i class="fas fa-share"></i>
        </span>
      </div>
      <p class="headline__text">
        使用頻度の高いToDoをショートカットとして登録できます。
      </p>
      <div class="page-action headline__page-action">
        <a
          @click="setShortcut"
          class="page-action__btn btn btn--main btn--sm"
        >
          <span class="page-action__icon">
            <i class="fas fa-plus"></i>
          </span>
          <span class="page-action__text">新規追加</span>
        </a>
      </div>
    </div>
    <ul class="list" v-if="this.getShortcuts.length">
      <li
        class="list__item"
        v-for="shortcut in this.getShortcuts"
        :key="shortcut.id"
      >
        <div class="list__block list__block--left">
          <div class="list__title" :class="{ 'list__title--with-label': shortcut.label_title }">
            {{ shortcut.title }}
          </div>
          <LabelItem :target-item="shortcut" v-if="shortcut.label_color" />
        </div>
        <div class="list__block list__block--right">
          <ItemAction :item="shortcut" @set-item="setShortcut" @delete-item="deleteShortcut" />
        </div>
      </li>
    </ul>
    <div class="no-result no-result" v-else>
      <div class="no-result__illustration">
        <img
          src="../images/illustrations/il-navigation.png"
          alt="チェックリストのイラスト"
        />
      </div>
    </div>
    <ShortcutModal
      @fetch-shortcuts="fetchShortcuts"
      ref="shortcutModal"
    />
  </div>
</template>

<script>
import { axiosForBackend } from "../config/axios";
import { mapGetters, mapActions } from "vuex";
import ItemAction from "./shared/item-action";
import ShortcutModal from "./shortcut-modal";
import LabelItem from "./label-item";
import Logout from "./mixins/logout";
import Flash from "./mixins/flash";

export default {
  name: "Shortcut",
  components: {
    ItemAction,
    ShortcutModal,
    LabelItem
  },
  mixins: [Logout, Flash],
  computed: {
    ...mapGetters({
      getShortcuts: "shortcut/getShortcuts"
    }),
  },
  methods: {
    ...mapActions({
      setShortcutsAction: "shortcut/setShortcutsAction",
    }),
    fetchShortcuts() {
      axiosForBackend
        .get("/shortcuts")
        .then((res) => {
          this.setShortcutsAction(res.data);
        })
        .catch(error => {
          this.forceLogout(error);
        });
    },
    setShortcut(shortcut) {
      if (this.getShortcuts.length >= 10 && !shortcut.id) {
        const message = "ショートカットが登録できるのは10個までです"
        this.generateFlash('error', message);
      } else {
        this.$refs.shortcutModal.setShortcutValue(shortcut);
      }
    },
    deleteShortcut(shortcut) {
      axiosForBackend.delete(`/shortcuts/${shortcut.id}`)
            .then(() => {
              this.fetchShortcuts();
            });
    }
  }
};
</script>
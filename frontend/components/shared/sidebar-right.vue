<template>
  <aside v-if="isTodo" class="sidebar sidebar-right">
    <div class="sidebar--stickey sidebar-right__inner">
      <SidebarShortcut class="display--sp" />
      <SidebarSearch @search-status='setSearchStatus' />
      <template v-if="!searchStatus">
        <SidebarCalendar />
        <SidebarShortcut class="display--pc" />
      </template>
    </div>
  </aside>
</template>

<script>
import SidebarSearch from "./sidebar-search";
import SidebarCalendar from "./sidebar-calendar";
import SidebarShortcut from "./sidebar-shortcut";

export default {
  data() {
    return {
      searchStatus: false 
    }
  },
  components: {
    SidebarSearch,
    SidebarCalendar,
    SidebarShortcut
  },
  computed: {
    isTodo() {
      return this.$route.name === 'todos';
    }
  },
  methods: {
    setSearchStatus(query) {
      this.searchStatus = false;
      if (query.length > 0) {
        this.searchStatus = true;
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebar-right {
  width: 250px;
  @media (max-width: 991px) {
    width: 100%;
  }

  &__search,
  &__calendar {
    margin-bottom: 20px;

    @media (max-width: 991px) {
      margin-bottom: 30px;
    }
  }
}

.display {
  &--pc {
    display: block;
    @media (max-width: 991px) {
      display: none;
    }
  }

  &--sp {
    display: none;

    @media (max-width: 991px) {
      display: block;
    }
  }
}
</style>
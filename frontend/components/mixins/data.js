import { axiosForBackend } from '../../config/axios';
import { mapGetters, mapActions } from 'vuex';
import Logout from './logout';

export default {
  mixins: [Logout],
  computed: {
    ...mapGetters({
      getSelectedDate: 'date/getSelectedDate',
    }),
  },
  methods: {
    ...mapActions({
      setSelectedDateAction: 'date/setSelectedDateAction',
      setCurrentUserAction: 'user/setCurrentUserAction',
      setTodosAction: 'todo/setTodosAction',
      setShortcutsAction: 'shortcut/setShortcutsAction',
      setLabelsAction: 'label/setLabelsAction',
    }),
    fetchData() {
      this.setSelectedDateAction();
      this.fetchUser();
      this.fetchShortcuts();
      this.fetchLabels();
      this.fetchTodos();
    },
    fetchUser() {
      axiosForBackend
        .get('/users/current')
        .then((res) => {
          this.setCurrentUserAction(res.data);
        })
        .catch((error) => {
          this.forceLogout(error);
        });
    },
    fetchTodos() {
      if (this.getSelectedDate) {
        axiosForBackend
          .get('/todos', { params: { date: this.getSelectedDate } })
          .then((res) => {
            this.setTodosAction(res.data);
          })
          .catch((error) => {
            this.forceLogout(error);
          });
      }
    },
    fetchShortcuts() {
      axiosForBackend
        .get('/shortcuts')
        .then((res) => {
          this.setShortcutsAction(res.data);
        })
        .catch((error) => {
          this.forceLogout(error);
        });
    },
    fetchLabels() {
      axiosForBackend
        .get('/labels')
        .then((res) => {
          this.setLabelsAction(res.data);
        })
        .catch((error) => {
          this.forceLogout(error);
        });
    },
  },
};

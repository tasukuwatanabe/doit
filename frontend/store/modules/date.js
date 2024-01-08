import { moment } from '../../modules/myMoment';

const namespaced = true;

const state = {
  selectedDate: {},
};

const getters = {
  getSelectedDate(state) {
    return state.selectedDate;
  },
};

const mutations = {
  setSelectedDate(state, date) {
    state.selectedDate = date;
  },
  resetSelectedDate(state) {
    state.selectedDate = '';
  },
};

const actions = {
  setSelectedDateAction({ commit }, set_date) {
    let selected_date;
    if (set_date) {
      selected_date = moment(set_date);
    } else {
      // 引数で日付が渡ってこない場合は当日の日付をセット
      selected_date = moment();
    }
    commit('setSelectedDate', selected_date);
  },
  resetSelectedDateAction({ commit }) {
    commit('resetSelectedDate');
  },
};

export default {
  namespaced,
  state,
  mutations,
  actions,
  getters,
};

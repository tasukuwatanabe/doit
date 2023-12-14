import moment from '../../modules/myMoment';

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
  setSelectedDateAction({ commit, state }, set_date) {
    let selected_date;
    if (set_date) {
      selected_date = moment(set_date);
    } else if (state.selectedDate) {
      selected_date = moment(state.selectedDate);
    } else {
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

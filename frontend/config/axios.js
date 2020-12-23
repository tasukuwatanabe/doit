import axios from 'axios';

// storeの読み込み
import store from '../store/index';

// Rails-APIを叩く際のaxiosのcors対策
axios.defaults.baseURL =
  process.env.NODE_ENV === 'production'
    ? 'https://doit-app.com/api/v1'
    : 'http://localhost:3000/api/v1';
axios.defaults.withCredentials = true;

axios.interceptors.request.use((request) => {
  store.commit('loading/addLoadingCount');
  return request;
});

axios.interceptors.response.use(
  (response) => {
    store.commit('loading/subtractLoadingCount');
    return response;
  },
  (error) => {
    store.commit('loading/subtractLoadingCount');
    return Promise.reject(error);
  }
);

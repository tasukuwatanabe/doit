// Vueの読み込み
import Vue from 'vue/dist/vue.esm';
import App from '../app';

// Vue.js起動時に、コンソールにヒントが表示されなくなる
Vue.config.productionTip = false;

// vue-router
import VueRouter from 'vue-router';
Vue.use(VueRouter);
import router from '../router/router';

// Font Awesome
import '../config/fontawesome';

// application.scss
import '../stylesheets/style.scss';

// Flash
import FlashMessage from '@smartweb/vue-flash-message';
Vue.use(FlashMessage);

// axios
import '../config/axios';

new Vue({
  store,
  router,
  render: (h) => h(App),
}).$mount('#app');

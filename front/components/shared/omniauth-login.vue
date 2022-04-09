<template>
  <div class="sns-login">
    <p class="sns-login__title">SNSでログイン</p>
    <ul class="sns-login__list">
      <li class="sns-login__item">
        <a :href="getServerHost + '/api/v1/auth/facebook'" class="sns-icon sns-icon--facebook">
          <i class="fab fa-facebook-f"></i>
        </a>
      </li>
      <li class="sns-login__item">
        <a :href="getServerHost + '/api/v1/auth/twitter'" class="sns-icon sns-icon--twitter">
          <i class="fab fa-twitter"></i>
        </a>
      </li>
      <li class="sns-login__item">
        <a :href="getServerHost + '/api/v1/auth/google_oauth2'"  class="sns-icon sns-icon--google">
          <i class="fab fa-google"></i>
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  computed: {
    getServerHost() {
      return process.env.NODE_ENV === 'production'
                                    ? 'https://doit-app.com'
                                    : 'http://localhost:3000';
    },
  }
}
</script>
<template>
  <div>
    <div class="container inner">
      <v-sidebar-left></v-sidebar-left>
      <div class="content">
        <div class="headline">
          <div class="headline__title">
            404 Not Found
            <span class="icon headline__icon">
              <i class="fas fa-search"></i>
            </span>
          </div>
          <div class="headline__text">
            指定されたページは見つかりませんでした。<br>URLが変わった、もしくはページが削除された可能性があります。
          </div>
        </div>
        <div class="no-result no-result">
          <div class="no-result__illustration">
            <img
              src="/illustrations/il-not-found.png"
              alt="404エラーのイラスト"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {

}
</script>
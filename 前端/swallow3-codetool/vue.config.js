module.exports = {
  outputDir: '..\\..\\后端\\codetool\\src\\main\\resources\\static',
  devServer: {
    port: 8088,
    proxy: {
      '^/api': {
        target: 'http://localhost:9000/',
        ws: true,
        changeOrigin: true
      }
    }
  },
  css: { // 配置css模块
    loaderOptions: { // 向预处理器 Loader 传递配置选项
      less: { // 配置less（其他样式解析用法一致）
        javascriptEnabled: true // 设置为true
      }
    }
  }
}

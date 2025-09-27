const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: '/',
  productionSourceMap: false,
  assetsDir: 'assets',

  devServer: {
    host: '0.0.0.0',
    port: 8080,
    allowedHosts: 'all',
    proxy: {
      '/api': {
        target: 'http://localhost:5000/api',
        changeOrigin: true,
        secure: false,                 // если бэкенд на self-signed https — оставить
        pathRewrite: { '^/api': '' },  // '/api/users' -> '/users'
        ws: true
      }
    }
  }
})

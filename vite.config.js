import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  build: {
    outDir: 'dist',
    rollupOptions: {
      output: {
        entryFileNames: 'mermaid-ascii-service/[name].js',
        chunkFileNames: 'mermaid-ascii-service/[name].js',
        assetFileNames: 'mermaid-ascii-service/[name].[ext]'
      }
    }
  },
})

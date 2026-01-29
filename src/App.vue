<template>
  <div class="app">
    <header class="header">
      <h1>Mermaid ASCII Service</h1>
      <button @click="renderDiagram" class="render-button">Render</button>
    </header>
    <div class="split-container">
      <div class="editor-pane">
        <div class="pane-label-wrapper">
          <label for="mermaid-input" class="pane-label">Mermaid Code</label>
          <button @click="copyEditorContent" class="copy-button" :class="{ copied: editorCopied }">
            <svg v-if="!editorCopied" class="copy-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
              <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
            </svg>
            <span v-else class="copied-text">Copied!</span>
          </button>
        </div>
        <textarea
          id="mermaid-input"
          v-model="mermaidCode"
          class="code-input"
          placeholder="Enter your Mermaid diagram code here..."
        ></textarea>
      </div>
      <div class="output-pane">
        <div class="pane-label-wrapper">
          <label class="pane-label">ASCII Output</label>
          <button @click="copyOutputContent" class="copy-button" :class="{ copied: outputCopied }">
            <svg v-if="!outputCopied" class="copy-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
              <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
            </svg>
            <span v-else class="copied-text">Copied!</span>
          </button>
        </div>
        <pre class="ascii-output">{{ asciiOutput }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { renderMermaidAscii } from 'beautiful-mermaid'

const mermaidCode = ref(`graph TD
  A[Start] --> B{Decision}
  B -->|Yes| C[Process]
  B -->|No| D[End]
  C --> D`)

const asciiOutput = ref('Click "Render" to generate ASCII diagram')

const editorCopied = ref(false)
const outputCopied = ref(false)

const copyToClipboard = async (text) => {
  try {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      await navigator.clipboard.writeText(text)
      return true
    } else {
      // Fallback for older browsers
      const textArea = document.createElement('textarea')
      textArea.value = text
      textArea.style.position = 'fixed'
      textArea.style.left = '-999999px'
      document.body.appendChild(textArea)
      textArea.focus()
      textArea.select()
      const success = document.execCommand('copy')
      document.body.removeChild(textArea)
      return success
    }
  } catch (error) {
    console.error('Failed to copy:', error)
    return false
  }
}

const copyEditorContent = async () => {
  const success = await copyToClipboard(mermaidCode.value)
  if (success) {
    editorCopied.value = true
    setTimeout(() => {
      editorCopied.value = false
    }, 2000)
  }
}

const copyOutputContent = async () => {
  const success = await copyToClipboard(asciiOutput.value)
  if (success) {
    outputCopied.value = true
    setTimeout(() => {
      outputCopied.value = false
    }, 2000)
  }
}

const renderDiagram = () => {
  try {
    if (!mermaidCode.value.trim()) {
      asciiOutput.value = 'Error: Please enter some Mermaid code'
      return
    }
    const result = renderMermaidAscii(mermaidCode.value)
    asciiOutput.value = result || 'No output generated'
  } catch (error) {
    asciiOutput.value = `Error: ${error.message}\n\n${error.stack || ''}`
  }
}
</script>

<style scoped>
.app {
  display: flex;
  flex-direction: column;
  height: 100vh;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background-color: #f5f5f5;
  border-bottom: 1px solid #ddd;
}

.header h1 {
  font-size: 1.5rem;
  color: #333;
  margin: 0;
}

.render-button {
  padding: 0.5rem 1.5rem;
  font-size: 1rem;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
}

.render-button:hover {
  background-color: #35a372;
}

.render-button:active {
  background-color: #2d8f5f;
}

.split-container {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.editor-pane,
.output-pane {
  flex: 1;
  display: flex;
  flex-direction: column;
  border-right: 1px solid #ddd;
}

.output-pane {
  border-right: none;
}

.pane-label-wrapper {
  position: relative;
  background-color: #f9f9f9;
  border-bottom: 1px solid #ddd;
}

.pane-label {
  padding: 0.75rem 1rem;
  font-weight: 500;
  font-size: 0.9rem;
  color: #666;
  display: block;
}

.copy-button {
  position: absolute;
  top: 50%;
  right: 0.5rem;
  transform: translateY(-50%);
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: background-color 0.2s;
  color: #666;
}

.copy-button:hover {
  background-color: #e9e9e9;
}

.copy-button:active {
  background-color: #ddd;
}

.copy-icon {
  width: 16px;
  height: 16px;
  stroke: currentColor;
}

.copied-text {
  font-size: 0.75rem;
  font-weight: 500;
  color: #42b983;
  white-space: nowrap;
}

.copy-button.copied {
  color: #42b983;
}

.code-input {
  flex: 1;
  padding: 1rem;
  border: none;
  resize: none;
  font-family: 'Courier New', Courier, monospace;
  font-size: 14px;
  line-height: 1.5;
  outline: none;
  background-color: #fff;
}

.ascii-output {
  flex: 1;
  padding: 1rem;
  margin: 0;
  overflow: auto;
  font-family: 'Courier New', Courier, monospace;
  font-size: 14px;
  line-height: 1.4;
  background-color: #fff;
  white-space: pre;
  color: #333;
}
</style>

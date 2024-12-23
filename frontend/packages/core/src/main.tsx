
import {StrictMode} from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'
import { LocaleProvider } from '@common/contexts/LocaleContext.tsx';
async function initializeApp() {
  try {
    // 初始化行为
    // await fetchInitialConfig(); // 示例：获取初始配置
    
    // 异步操作完成后，渲染React消费者
    ReactDOM.createRoot(document.getElementById('root')!).render(
      <StrictMode>
        <LocaleProvider>
          <App />
        </LocaleProvider>
       </StrictMode>,
    );
  } catch (error) {
    console.error('Initialization failed:', error);
    // 处理初始化失败的情况，比如渲染一个错误界面
  }
}

// 执行初始化
initializeApp();
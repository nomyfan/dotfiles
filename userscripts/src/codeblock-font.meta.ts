import type { MonkeyUserScript } from "vite-plugin-monkey";

export const meta: MonkeyUserScript = {
  name: "Codeblock font",
  namespace: "https://github.com/nomyfan/dotfiles/userscripts",
  version: "0.1.0",
  description: "Override font-family of the code block with custom font",
  author: "nomyfan",
  match: [
    "https://github.com/*",
    "https://huggingface.co/*",
    "https://claude.ai/*",
    "https://chatgpt.com/*",
  ],
};

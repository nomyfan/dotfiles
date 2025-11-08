import type { MonkeyUserScript } from "vite-plugin-monkey";

export const meta: MonkeyUserScript = {
  name: "GitHub Quick Actions",
  namespace: "https://github.com/nomyfan/dotfiles/userscripts",
  version: "0.1.0",
  description: "My quicks actions for GitHub",
  author: "nomyfan",
  match: ["https://github.com/*"],
  "run-at": "document-idle",
};

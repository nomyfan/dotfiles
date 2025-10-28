import type { MonkeyUserScript } from "vite-plugin-monkey";

export const meta: MonkeyUserScript = {
  name: "Unsplash fullscreen",
  namespace: "https://github.com/nomyfan/dotfiles/userscripts",
  version: "0.3.2",
  description:
    "Add a fullscreen button to Unsplash to view photos in fullscreen mode",
  author: "nomyfan",
  match: ["https://unsplash.com/*"],
};

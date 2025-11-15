import type { MonkeyUserScript } from "vite-plugin-monkey";

export const meta: MonkeyUserScript = {
  name: "Goto Alphaxiv",
  namespace: "https://github.com/nomyfan/dotfiles/userscripts",
  version: "0.1.0",
  description: "Navigate to Alphaxiv from Arxiv paper page.",
  author: "nomyfan",
  match: ["https://arxiv.org/*"],
};

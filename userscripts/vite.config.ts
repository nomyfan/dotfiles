import { defineConfig } from "vite";
import monkey from "vite-plugin-monkey";
import { meta } from "./dev.meta";

export default defineConfig(({ command }) => {
  if (command === "build") {
    return {};
  }
  return {
    plugins: [
      monkey({
        entry: "dev.ts",
        userscript: meta,
      }),
    ],
  };
});

import * as fs from "node:fs/promises";
import * as vite from "vite";
import monkey from "vite-plugin-monkey";
import type { MonkeyUserScript } from "vite-plugin-monkey";

const files = await fs.readdir("./src");
const metaFiles = files.filter((f) => f.endsWith(".meta.ts"));

const userscripts: Record<
  string,
  { entry: string; meta: () => Promise<{ meta: MonkeyUserScript }> }
> = Object.fromEntries(
  metaFiles.map((file) => {
    const name = file.replace(".meta.ts", "");
    return [
      name,
      {
        entry: `src/${name}.ts`,
        meta: () => import(`./src/${name}.meta`),
      },
    ];
  })
);

async function build(name: string) {
  const userscript = userscripts[name];
  if (!userscript) {
    throw new Error(`Unknown userscript: ${name}`);
  }
  await vite.build({
    plugins: [
      monkey({
        entry: userscript.entry,
        userscript: (await userscript.meta()).meta,
        build: {
          fileName: `${name}.user.js`,
        },
      }),
    ],
    build: {
      emptyOutDir: false,
    },
  });
}

const args = process.argv.slice(2);
let names = args;
if (names.length === 0) {
  names = Object.keys(userscripts);
}

await fs.rm("./dist", { recursive: true, force: true });
for (const name of names) {
  await build(name).catch((err) => {
    console.error(err);
    process.exit(1);
  });
}

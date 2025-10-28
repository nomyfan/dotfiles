const buildCss = (selector: string) => `${selector} {
  font-family: 'Berkeley Mono' !important;
}\n`;
const css =
  buildCss("body .markdown-body pre>code") +
  buildCss("body .markdown-body .highlight pre, .markdown-body pre") +
  buildCss("body code") +
  buildCss("body .code-block > pre") +
  buildCss("body .code-block > pre *[class^=hljs-]") +
  buildCss("body .react-code-lines .react-code-text") +
  buildCss("body .react-code-lines .react-code-text > *") +
  buildCss("body .code-block__code > code[class*=language-]") + // claude
  buildCss("body code[class*=language-]"); // chatgpt
const styleEl = document.createElement("style");
styleEl.id = "berkeley-mono-font";
styleEl.innerHTML = css;
document.head.appendChild(styleEl);

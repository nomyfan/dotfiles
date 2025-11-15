const ICON = `<svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 718.41 504.47" class="text-custom-red size-8"><polygon fill="currentColor" points="591.15 258.54 718.41 385.73 663.72 440.28 536.57 313.62 591.15 258.54"></polygon><path fill="currentColor" d="M273.86.3c34.56-2.41,67.66,9.73,92.51,33.54l94.64,94.63-55.11,54.55-96.76-96.55c-16.02-12.7-37.67-12.1-53.19,1.11L54.62,288.82,0,234.23,204.76,29.57C223.12,13.31,249.27,2.02,273.86.3Z"></path><path fill="currentColor" d="M663.79,1.29l54.62,54.58-418.11,417.9c-114.43,95.94-263.57-53.49-167.05-167.52l160.46-160.33,54.62,54.58-157.88,157.77c-33.17,40.32,18.93,91.41,58.66,57.48L663.79,1.29Z"></path></svg>`;

function createSVGElementFromString(svgString: string): SVGElement {
  const div = document.createElement("div");
  div.innerHTML = svgString.trim();
  const svg = div.firstChild;
  svg.remove();
  return svg as SVGElement;
}

function main() {
  const url = new URL(location.href);
  const components = url.pathname.split("/").filter(Boolean);
  if (components.length !== 2 && components[0] !== "abs") {
    return;
  }

  const paperId = components[1];
  const ul = document.querySelector(".extra-services ul:has(+ .abs-license)");
  if (!ul || ul.querySelector("#alphaxiv-link")) return;

  const a = document.createElement("a");
  a.id = "alphaxiv-link";
  a.href = `https://alphaxiv.org/abs/${paperId}`;
  a.rel = "noopener noreferrer";
  a.target = "_blank";
  a.appendChild(createSVGElementFromString(ICON));
  a.appendChild(document.createTextNode("Alphaxiv"));
  a.style.cssText =
    "display: flex; align-items: center; gap: 4px; font-weight: bold; color: #9a2036; padding: 4px 4px 4px 0;";
  ul.appendChild(a);
}

main();

setInterval(() => {
  main();
}, 1000);

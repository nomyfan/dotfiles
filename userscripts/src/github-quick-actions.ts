const globalStyleID = "gh-quick-actions-style";
function main() {
  if (!document.getElementById(globalStyleID)) {
    const globalStyleEle = document.createElement("style");
    globalStyleEle.id = globalStyleID;
    globalStyleEle.textContent = `
      #repository-details-container {
        max-width: unset !important;
      }
    `;
    document.head.appendChild(globalStyleEle);
  }

  const url = new URL(location.href);
  const components = url.pathname.split("/").filter(Boolean);
  if (
    components.length !== 2 &&
    !(components.length === 4 && components[2] === "tree")
  ) {
    return;
  }

  const actionsBar = document.querySelector(".pagehead-actions");
  if (!actionsBar) return;
  if (actionsBar.querySelector('[data-testid="gh-quick-action"]')) {
    return;
  }

  const owner = components[0];
  const name = components[1];
  const rev = components.length === 4 ? components[3] : "";

  const actions: {
    link: string;
    icon: string;
    name: string;
    style?: string;
  }[] = [
    {
      link: `https://sourcegraph.com/github.com/${owner}/${name}${
        rev ? `@${encodeURIComponent(rev)}` : ""
      }`,
      icon: `<svg xmlns="http://www.w3.org/2000/svg" fill="#FF5543" viewBox="0 0 24 24" style="height:12px"><path d="m9.663 6.991 3.238.862L10.8 0 7.065 1.005l1.227 4.611c.178.67.704 1.197 1.371 1.375M10.894 15.852l.1-.099.037.135L13.2 24l3.735-1.005-.914-3.434-2.443-9.15L.993 7.058 0 10.81l8.103 2.165.134.037-.097.099-5.94 5.944 2.729 2.752zM16.131 11.086l.867 3.25c.18.67.705 1.197 1.374 1.375l4.637 1.233.992-3.753-7.868-2.105zM15.464 8.522l1.824.067h.07c.515 0 1-.201 1.363-.567l3.077-3.08-2.728-2.751-2.987 2.982a1.94 1.94 0 0 0-.57 1.329l-.05 2.02"/></svg>`,
      name: "Sourcegraph",
    },
    {
      link: `https://zread.ai/${owner}/${name}`,
      icon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABsAAAAcCAYAAACQ0cTtAAAAoklEQVR4Ae3WsRGFIBCEYUqgCHt5ySO0ChNzu7ILm6AJCkAINnHkjmFnLpHgz3buy1AXQjhKqVEs+d/+d1p1V4rCraOOstLWiW3aLVfViUlNLBMYoAV7DVtLV6NzAIqNW6t4aASS9gzkeyFkBgFjoSTsaSyNQDUTCI1AyBOYCEUGQiYQMoEQnqu3JyY9oIWBgGUlGkLEJ+Yr2MSyJdb/+012A4434NnmjZERAAAAAElFTkSuQmCC",
      name: "Zread",
    },
    {
      link: `https://deepwiki.com/${owner}/${name}`,
      icon: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAMAAABF0y+mAAAAdVBMVEVHcExXd8pfmdlLbsZDZ8RNb8dhfs1YeMpEaMRxn9t/zrRNcMd8rNNIa8VkwqJdv51lw6JRcshwx6lgwJ9pxKWez9trxqdcv5xqxaZzyay32eJVn91Hl9tBk9lLmdtlqeFcvpxIl9tKmNtRnNxRndxaot9Unt03h7TUAAAAJ3RSTlMAj2L///VTdf80PMIm/9v/7tuA/74XoP90XgmM///pRv/F88+1WXU/zfQTAAAA8UlEQVR4AY3RBRKDUAwE0IUGd3eo3/+IzZe6sThvYCeA9TGMr2RuiCz7sznkitif0f2CniiURgL9B7ItNwjtiDSGcZLeOOO7xIvlEkUG8oRTlMoq1RWF8LIsBOJE6hMGkPmKVVlWqIpHhEUCDdRF0xRx0UiMbxNGxGWtvNsUXZfyDrf0Yrg2kWkB3EnUmnfMBfZ3G8ZpXvRrk6Lt0m2RX22cRAbkRcPDF6o61e+cZHZilLq/j/KCKvEHHD0s+9l7QRwmzWJ35GqBpUZ+YjqGizCOydVJ/PhHQzGQwpO6fMn5jviGCz7mtJ/El/qW4YzVuQCH8hlPYGhUDAAAAABJRU5ErkJggg==",
      name: "DeepWiki",
      style: "height: 12px; transform: scale(1.2)",
    },
  ];

  const nodes: HTMLElement[] = [];
  for (const action of actions) {
    const li = document.createElement("li");
    const a = document.createElement("a");
    a.dataset.testid = "gh-quick-action";
    a.href = action.link;
    a.className = "btn btn-sm";
    a.style.cssText = "display: flex; align-items: center; gap: 4px;";
    if (action.icon.startsWith("data:") || action.icon.startsWith("https://")) {
      const img = document.createElement("img");
      img.src = action.icon;
      img.style.cssText = action.style || "height: 12px;";
      a.appendChild(img);
      a.appendChild(document.createTextNode(action.name));
    } else {
      // SVG or text
      a.innerHTML = action.icon;
      a.appendChild(document.createTextNode(action.name));
    }
    a.target = "_blank";
    a.rel = "noopener noreferrer";
    li.appendChild(a);
    nodes.unshift(li);
  }

  actionsBar.prepend(...nodes);
}

main();

setInterval(() => {
  main();
}, 1000);

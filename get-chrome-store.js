// @ts-check
import strict from "node:assert/strict";
import fs from "node:fs";

(async () => {

  const ID        = process.argv[2] ?? 'plpkmjcnhhnpkblimgenmdhghfgghdpp';
  const FILE      = process.argv[3] ?? 'the-great-er-discarder-er';

  /**
   * @param {{ data?: any[]; }} input
   */
  function AF_initDataCallback(input) {
    const val     = input.data?.[0];
    if (val) {
      // console.log(val);
      const obj   = {
        icon      : val[1],
        title     : val[2],
        rating    : val[3],
        ratings   : val[4],
        desc      : val[6],
        users     : val[14],
        version   : (val[18].match(/["']version["']:\s*["'](.*?)["']/i) || [])[1],
      }
      return obj;
    }
  }

  const response  = await fetch(`https://chromewebstore.google.com/detail/${ID}`);
  const body      = await response.text();
  // const match     = body.match(/<script.*?>.*?AF_initDataCallback(.*?)<\/script>/is);
  const re        = /(AF_initDataCallback\(.+?\);)<\/script>/isg;
  let match;
  while (match = re.exec(body)) {
    const obj     = eval(match[1]);
    if (obj) {
      // console.log(obj);
      obj.users   = Number(obj.users).toLocaleString();
      obj.rating  = Number(obj.rating).toLocaleString('en-US', {
        minimumFractionDigits: 1,
        maximumFractionDigits: 1,
      });
      const icon  = await fetch(obj.icon);
      if (icon) {
        const arrayBuffer = await icon.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        const base64Image = buffer.toString('base64');
        obj.icon  = `data:image/png;base64,${base64Image}`
      }
      const svg   = `
<svg
  width="400"
  height="150"
  viewBox="0 0 400 150"
  fill="none"
  xmlns="http://www.w3.org/2000/svg"
  role="img"
>
  <title id="titleId"></title>
  <desc id="descId"></desc>
  <style>
    .header {
      font: 600 18px 'Segoe UI', Ubuntu, Sans-Serif;
      fill: #4493F8;
      animation: fadeInAnimation 0.8s ease-in-out forwards;
    }
    @supports(-moz-appearance: auto) {
      /* Selector detects Firefox */
      .header { font-size: 15.5px; }
    }

    .description { font: 400 13px 'Segoe UI', Ubuntu, Sans-Serif; fill: #888888; color: #888888 }
    .gray { font: 400 12px 'Segoe UI', Ubuntu, Sans-Serif; fill: #888888 }
    .icon { fill: #4493F8 }
    .badge { font: 600 11px 'Segoe UI', Ubuntu, Sans-Serif; }
    .badge rect { opacity: 0.2 }

    /* Animations */
    @keyframes scaleInAnimation {
      from {
        transform: translate(-5px, 5px) scale(0);
      }
      to {
        transform: translate(-5px, 5px) scale(1);
      }
    }
    @keyframes fadeInAnimation {
      from {
        opacity: 0;
      }
      to {
        opacity: 1;
      }
    }

    * { animation-duration: 0s !important; animation-delay: 0s !important; }
  </style>

  <rect
    data-testid="card-bg"
    x="0.5"
    y="0.5"
    rx="4.5"
    height="99%"
    stroke="#888888"
    width="399"
    fill="#ffffff00"
    stroke-opacity="1"
  />

  <g
    data-testid="card-title"
    transform="translate(25, 35)"
  >

    <g transform="translate(0, 0)">
      <image
        x="0"
        y="-16"
        width="20"
        height="20"
        href="${obj.icon}"
      />
    </g>
    <g transform="translate(25, 0)">
      <text x="0" y="0" class="header" data-testid="header">
        ${obj.title}
      </text>
      <text x="325" y="0" text-anchor="end" class="header" data-testid="header">
        v${obj.version}
      </text>
    </g>

    <foreignObject x="0" y="0" width="300" height="100">
      <p xmlns="http://www.w3.org/1999/xhtml" class="description">
        ${obj.desc}
      </p>
    </foreignObject>

  </g>

  <g
    data-testid="main-card-body"
    transform="translate(0, 55)"
  >

  <g transform="translate(26, 70)">

  <g transform="translate(0, 0)">

    <g transform="translate(2, 0)">
      <svg
        class="icon"
        y="-12"
        viewBox="0 0 448 512"
        width="16"
        height="16"
      >
        <path d="M313.6 304c-28.7 0-42.5 16-89.6 16-47.1 0-60.8-16-89.6-16C60.2 304 0 364.2 0 438.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-25.6c0-74.2-60.2-134.4-134.4-134.4zM400 464H48v-25.6c0-47.6 38.8-86.4 86.4-86.4 14.6 0 38.3 16 89.6 16 51.7 0 74.9-16 89.6-16 47.6 0 86.4 38.8 86.4 86.4V464zM224 288c79.5 0 144-64.5 144-144S303.5 0 224 0 80 64.5 80 144s64.5 144 144 144zm0-240c52.9 0 96 43.1 96 96s-43.1 96-96 96-96-43.1-96-96 43.1-96 96-96z"/>
      </svg>
      <g transform="translate(20, 1)">
        <text data-testid="users" class="gray">
          ${obj.users} users
        </text>
      </g>
    </g>

    <g transform="translate(100, 0)">
      <svg
        class="icon"
        y="-12"
        viewBox="0 0 576 512"
        version="1.1"
        width="16"
        height="16"
      >
        <path d="M528.1 171.5L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6zM388.6 312.3l23.7 138.4L288 385.4l-124.3 65.3 23.7-138.4-100.6-98 139-20.2 62.2-126 62.2 126 139 20.2-100.6 98z"/>
      </svg>
      <g transform="translate(20, 1)">
        <text data-testid="ratings" class="gray">
          ${obj.rating}
        </text>
        <g transform="translate(24, 0)">
        <text data-testid="ratings" class="gray">
          (${obj.ratings} ratings)
        </text>
        </g>
      </g>

      <image class="store-logo"
        x="120"
        y="-26"
        width="140"
        href="data:image/png;base64,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"
        opacity="1.0"
      />

    </g>
  </g>

  </g>

  </g>
</svg>
      `;

      fs.writeFileSync(`images/${FILE}-chrome.svg`, svg)
    }
  }

})();

// ==UserScript==
// @name MediaWiki Sidebar Toggle
// @description Toggle the Mediawiki Side Bar with Control-Apostrophe
// @version 1.0
// @minGMVer 1.14
// @minFFVer 26
// @namespace Mediawiki-Sidebar-Toggle
// @license MIT; https://unlicense.org/
// @include http://*.wikipedia.org/*
// @include https://*.wikipedia.org/*
// @include https://wiki.alpinelinux.org/*
// @include https://wiki.archlinux.org/*
// @include http://nethackwiki.com/*
// @include https://nethackwiki.com/*
// @include https://wiki.greasespot.net/*
// ==/UserScript==

/*
 * Example of this script in action:
 * https://u.winny.tech/pub/mediawiki-sidebar-toggle.webm
 */

/* jshint esversion: 6 */


(function() {
  'use strict';
  const panel = document.getElementById('mw-panel') ||
        document.getElementById('sidebar');
  const content = document.getElementById('content');
  const [body] = document.getElementsByTagName('body');
  const [head] = document.getElementsByTagName('head');
  const toggleParent = document.getElementById('mw-head') || body;
  if (panel == null || content == null || head === null || body == null) {
    console.log(`mediawiki-hide-bar.js: panel:${panel} content:${content} body:${body} head:${head} something is null, returning.`);
    return;
  }

  /* The sidebar toggle function. */
  function toggleSidebar() {
    if (panel.style.display !== 'none') {
      panel.style.display = 'none';
      content.style.marginLeft = '0';
      content.style.borderLeftWidth = '0';
    } else {
      panel.style.display = null;
      content.style.marginLeft = null;
      content.style.borderLeftWidth = null;
    }
  }

  /* Add a stylesheet. */
  const css = `
.toggle-sidebar {
  position: absolute;
  left: 0;
  top: 0;
  z-index: 100;

  opacity: .30;
  padding: .2em;
  background: darkgray;

  -ms-user-select: none;
  -moz-user-select: none;
  -webkit-user-select: none;
  user-select: none;
}

.toggle-sidebar:hover {
  opacity: 1;
}
`;
  const style = document.createElement('style');
  if (style.styleSheet) {
    style.styleSheet.cssText = css;
  } else {
    style.appendChild(document.createTextNode(css));
  }
  head.appendChild(style);

  /* Add the clickable toggle. */
  const toggleElement = document.createElement('div');
  toggleElement.classList.add('toggle-sidebar');
  const a = document.createElement('a');
  a.addEventListener('click', toggleSidebar);
  a.innerText = 'Toggle sidebar';
  toggleElement.appendChild(a);
  toggleParent.appendChild(toggleElement);

  /* Add the Control-' binding. */
  body.addEventListener('keydown', (e) => {
    // Check modifiers.
    if (!e.ctrlKey || e.altKey || e.metaKey || e.shiftKey) return;
    // Check the key itself.
    if (e.key !== "'") return;

    toggleSidebar();
  });
})();

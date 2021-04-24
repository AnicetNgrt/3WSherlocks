// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


/// BEGIN BORROW

// https://github.com/elixirschool/live-view-chat/blob/master/assets/js/app.js
// Apache License 2.0
// Lets you have automatic scrolling to bottom in messages lists

// Select the node that will be observed for mutations
const container = document.getElementsByClassName("messages")[0]

console.log(JSON.stringify(container))

document.addEventListener("DOMContentLoaded", function() {
  console.log(JSON.stringify(container.scrollTop))
  console.log(JSON.stringify(container.scrollTopMax))
  console.log(JSON.stringify(container.scrollHeight))
  container.scrollTop = container.scrollHeight
  console.log(JSON.stringify(container.scrollTop))
  console.log(container)
});

// Options for the observer (which mutations to observe)
let config = { attributes: true, childList: true, subtree: true };
// Callback function to execute when mutations are observed
var callback = function(mutationsList, observer) {
  for(var mutation of mutationsList) {
    if (mutation.type == 'childList') {
      
    }
  }
};
// Create an observer instance linked to the callback function
var observer = new MutationObserver(callback);
// Start observing the target node for configured mutations
observer.observe(container, config);

/// END BORROW
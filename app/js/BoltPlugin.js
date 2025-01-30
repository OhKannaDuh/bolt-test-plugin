const BOLT_LUA_API_MESSAGE_ENDPOINT = "https://bolt-api/send-message";
const BOLT_LUA_API_REPOSITION_ENDPOINT =
  "https://bolt-api/start-reposition?h=0&v=0";

class BoltPlugin {
  app = null;

  constructor(app) {
    window.addEventListener("message", async (event) => {
      plugin.on_message(event);
    });

    this.app = app;
    this.app.plugin = this;
  }

  // Send a message to bolt, which should be recieved by BROWSER:onmessage
  message(type, data) {
    return fetch(BOLT_LUA_API_MESSAGE_ENDPOINT, {
      method: "POST",
      body: JSON.stringify({
        type: type,
        data: data,
      }),
    });
  }

  start_reposition() {
    return fetch(BOLT_LUA_API_REPOSITION_ENDPOINT, {
      method: "POST",
    });
  }

  message_callbacks = [];
  add_message_callback(callback) {
    this.message_callbacks.push(callback);
  }

  on_message(event) {
    console.log(event);
    if (typeof event.data !== "object" || event.data.type !== "pluginMessage")
      return;

    // Decode message
    let message = "";
    const bytes = new Uint8Array(event.data.content);
    for (let i = 0; i < bytes.byteLength; i++) {
      message += String.fromCharCode(bytes[i]);
    }

    for (const i in this.message_callbacks) {
      this.message_callbacks[i](message);
    }
  }
}

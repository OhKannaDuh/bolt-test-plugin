const { createApp, ref } = Vue;

let tasks = ref([]);
let height = ref(0);

const app = createApp({
  setup: () => {
    return {
      tasks: tasks,
      plugin: ref(null),
      height: height,

      tabs: ref([
        {
          key: "daily",
          label: "Daily",
          show: true,
        },
        {
          key: "weekly",
          label: "Weekly",
          show: false,
        },
        {
          key: "monthly",
          label: "Monthly",
          show: false,
        },
      ]),

      checkbox_change: function () {
        plugin.message("tasks", tasks.value);
      },

      close: function () {
        plugin.message("close");
      },

      count_complete: function (key) {
        let count = 0;

        for (const task of this.tasks[key]) {
          if (task.value) {
            count++;
          }
        }

        return count;
      },

      show: function (tab) {
        for (const data of this.tabs) {
          data.show = false;

          if (data.key === tab.key) {
            data.show = true;
          }
        }
      },
    };
  },
  mounted: () => {
    console.log("mounted");
  },
}).mount("#app");

const plugin = new BoltPlugin(app);

plugin.add_message_callback(function (message) {
  message = JSON.parse(message);

  switch (message.type) {
    case "tasks":
      tasks.value = message.data;
      break;
    case "config":
      height.value = message.data.window.height;
      tasks.value = message.data.tasks;
      break;
    default:
      console.warn(`Unhandled message type: ${message.type}`);
      break;
  }
});

window.addEventListener("DOMContentLoaded", () => {
  plugin.message("ready");

  document
    .getElementById("toolbar-drag")
    .addEventListener("mousedown", (event) => {
      plugin.start_reposition();
    });
});

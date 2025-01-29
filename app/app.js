const { createApp, ref } = Vue;

let tasks = ref([]);

const app = createApp({
  setup: () => {
    return {
      tasks: tasks,
      input: ref({
        daily: "",
        weekly: "",
        monthly: "",
      }),
      plugin: ref(null),
      checkbox_change: function () {
        plugin.send_message_to_lua(
          JSON.stringify(
            {
              type: "tasks",
              data: tasks,
            },
            null,
            2
          )
        );
      },
      add_daily: function () {
        if (plugin.app.input.daily.trim() == "") return;
        console.log(plugin.app.input.daily.trim());
      },
    };
  },
}).mount("#app");

const plugin = new BoltPlugin(app);

plugin.add_message_callback(function (message) {
  tasks.value = JSON.parse(message);

  console.log(tasks.value.weekly.length);
});

window.addEventListener("DOMContentLoaded", () => {
  plugin.send_message_to_lua(JSON.stringify({ type: "ready" }));

  document
    .getElementById("draggable")
    .addEventListener("mousemove", (event) => {
      plugin.start_reposition();
    });
});

import { invoke } from "@tauri-apps/api/tauri";
import { Elm } from "./Main.elm";

const app = Elm.Main.init({
  node: document.getElementById("root"),
  flags: null
});

app.ports.sendMessage.subscribe(async (message: string) => {
  const response: string = await invoke("greet", {
    name: message
  });
  app.ports.messageReceiver.send(response);
});


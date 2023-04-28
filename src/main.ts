import { Elm } from "./Main.elm";
import { emit, listen } from '@tauri-apps/api/event'


async function f() {
  await listen("back-to-front", event => {
    app.ports.messageReceiver.send(event.payload as string);
  });
}
f();

const app = Elm.Main.init({
  node: document.getElementById("root"),
  flags: null
});


app.ports.sendMessage.subscribe(async () => {
  emit('front-to-back', "hello from front");
});


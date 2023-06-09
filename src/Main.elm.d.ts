// WARNING: Do not manually modify this file. It was generated using:
// https://github.com/dillonkearns/elm-typescript-interop
// Type definitions for Elm ports

export namespace Elm {
    namespace Main {
        export interface App {
            ports: {
                sendMessage: {
                    subscribe(callback: (data: string) => void): void
                }
                messageReceiver: {
                    send(data: string): void
                }
            };
        }
        export function init(options: {
            node?: HTMLElement | null;
            flags: null;
        }): Elm.Main.App;
    }
}
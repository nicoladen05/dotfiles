import ponytailExtension from "../npm/node_modules/@dietrichgebert/ponytail/pi-extension/index.js";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const hidePonytailStatus = (ctx: any) => {
    if (!ctx?.ui?.setStatus) return ctx;

    return {
      ...ctx,
      ui: {
        ...ctx.ui,
        setStatus(key: string, text?: string) {
          if (key === "ponytail") return;
          return ctx.ui.setStatus(key, text);
        },
      },
    };
  };

  const wrappedPi = new Proxy(pi as any, {
    get(target, prop) {
      if (prop === "on") {
        return (event: string, handler: any) =>
          target.on(event, (payload: any, ctx: any) => handler(payload, hidePonytailStatus(ctx)));
      }

      if (prop === "registerCommand") {
        return (name: string, command: any) =>
          target.registerCommand(name, {
            ...command,
            handler: (args: string, ctx: any) => command.handler(args, hidePonytailStatus(ctx)),
          });
      }

      const value = target[prop];
      return typeof value === "function" ? value.bind(target) : value;
    },
  });

  ponytailExtension(wrappedPi);
}

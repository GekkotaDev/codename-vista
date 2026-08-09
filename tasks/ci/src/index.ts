import { type Command, run } from "@drizzle-team/brocli";

import scan from "$command/scan";

const commands: Command[] = [scan];

await run(commands, {
  name: "actions",
  description: "",
});

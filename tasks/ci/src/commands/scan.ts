import fs from "node:fs";
import path from "node:path";

import { command } from "@drizzle-team/brocli";
import consola from "consola";
import { fdir } from "fdir";
import pc from "picocolors";

import { loop } from "$utils/fp";

const allowlist = new Set([
  "assets",
  "data",
  "docs",
  "examples",
  "nodes",
  "resources",
  "scenes",
  "screens",
  "scripts",
  "services",
  "views",
]);

const messages = {
  useless: [
    pc.bold("Why Not?"),
    [
      `Long-term ${pc.italic("nobody")} will understand what you wrote here because it is completely`,
      `completely different from the established conventions set throughout this code`,
      `base.`,
      "",
      `Instead of inventing your own folder structure nobody else understands, follow`,
      `the one that already exists, otherwise file an RFC.`,
    ].join("\n"),
    "",
    pc.italic(
      pc.dim("And please, quit using AI. That glorified autocorrect is stinking up your code"),
    ),
    pc.italic(pc.dim("so nasty it's an unreadable mess.")),
  ].join("\n"),
};

export default command({
  name: "scan",

  handler() {
    const workspaceDirectory = loop(process.cwd())((directory, callback): string => {
      if (directory === path.parse(directory).root)
        consola.error(new Error("No project.godot found."));

      const isRoot =
        new fdir()
          .crawl(directory)
          .sync()
          .filter((file) => file === "project.godot").length > 0;

      return isRoot ? directory : callback(directory, callback);
    });

    const features = fs
      .readdirSync(`${workspaceDirectory}/modules`, {
        withFileTypes: true,
      })
      .filter((entry) => entry.isFile() === false);

    const forbidden = features
      .map((feature) => {
        const parent = `${feature.parentPath}/${feature.name}`;
        const entries = new Set(
          fs
            .readdirSync(parent, {
              withFileTypes: true,
            })
            .filter((entry) => entry.isFile() === false)
            .map((entry) => entry.name),
        );

        return new Set(
          [...entries.difference(allowlist)].map((forbidden) => `${parent}/${forbidden}`),
        );
      })
      .reduce((previous, current) => previous.union(current));

    if (forbidden.size > 0) {
      consola.error(
        [
          pc.bold("Unnecessary folders found"),
          forbidden
            .values()
            .toArray()
            .map((target) => `\t${pc.yellow("->")} ${path.normalize(target)}`)
            .join("\n"),
        ].join("\n"),
      );

      consola.box(
        messages.useless
          .trim()
          .split("\n")
          .map((slice) => slice.trim())
          .join("\n"),
      );

      process.exit(1);
    }
  },
});

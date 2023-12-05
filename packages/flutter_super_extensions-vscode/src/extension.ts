import * as _ from "lodash";

import { commands, ExtensionContext, languages, workspace } from "vscode";
import { analyzeDependencies } from "./utils";
import {
  newModule,
  wrapWithSuperBuilder,
  wrapWithSuperListener,
  wrapWithSuperConsumer,
  wrapWithAsyncBuilder,
  wrapWithSuperApp,
} from "./commands";
import { SuperCodeActionProvider } from "./code-actions";

const DART_MODE = { language: "dart", scheme: "file" };

export function activate(_context: ExtensionContext) {
  if (workspace.getConfiguration("flutter-super").get<boolean>("checkForUpdates")) {
    analyzeDependencies();
  }

  _context.subscriptions.push(
    commands.registerCommand("extension.new-module", newModule),
    commands.registerCommand("extension.wrap-superbuilder", wrapWithSuperBuilder),
    commands.registerCommand(
      "extension.wrap-superapp",
      wrapWithSuperApp
    ),
    commands.registerCommand(
      "extension.wrap-superlistener",
      wrapWithSuperListener
    ),
    commands.registerCommand(
      "extension.wrap-superconsumer",
      wrapWithSuperConsumer
    ),
    commands.registerCommand(
      "extension.wrap-asyncbuilder",
      wrapWithAsyncBuilder
    ),
    languages.registerCodeActionsProvider(
      DART_MODE,
      new SuperCodeActionProvider()
    )
  );
}

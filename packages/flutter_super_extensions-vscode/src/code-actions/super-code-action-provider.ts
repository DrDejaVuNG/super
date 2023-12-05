import { window, CodeAction, CodeActionProvider, CodeActionKind } from "vscode";

export class SuperCodeActionProvider implements CodeActionProvider {
  public provideCodeActions(): CodeAction[] {
    const editor = window.activeTextEditor;
    if (!editor) return [];

    return [
      {
        command: "extension.wrap-superapp",
        title: "Wrap with SuperApp",
      },
      {
        command: "extension.wrap-asyncbuilder",
        title: "Wrap with AsyncBuilder",
      },
      {
        command: "extension.wrap-superbuilder",
        title: "Wrap with SuperBuilder",
      },
      {
        command: "extension.wrap-superconsumer",
        title: "Wrap with SuperConsumer",
      },
      {
        command: "extension.wrap-superlistener",
        title: "Wrap with SuperListener",
      },
    ].map((c) => {
      let action = new CodeAction(c.title, CodeActionKind.Refactor);
      action.command = {
        command: c.command,
        title: c.title,
      };
      return action;
    });
  }
}

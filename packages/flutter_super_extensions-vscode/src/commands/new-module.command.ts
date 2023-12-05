import * as _ from "lodash";
import * as changeCase from "change-case";
import * as mkdirp from "mkdirp";

import {
  InputBoxOptions,
  OpenDialogOptions,
  Uri,
  window,
  workspace,
} from "vscode";
import { existsSync, lstatSync, writeFile } from "fs";
import {
  getModuleViewTemplate,
  getModuleControllerTemplate,
  getModuleTemplate,
} from "../templates";

export const newModule = async (uri: Uri) => {
  const moduleName = await promptForModuleName();
  if (_.isNil(moduleName) || moduleName.trim() === "") {
    window.showErrorMessage("The module name must not be empty");
    return;
  }

  let targetDirectory;
  if (_.isNil(_.get(uri, "fsPath")) || !lstatSync(uri.fsPath).isDirectory()) {
    targetDirectory = await promptForTargetDirectory();
    if (_.isNil(targetDirectory)) {
      window.showErrorMessage("Please select a valid directory");
      return;
    }
  } else {
    targetDirectory = uri.fsPath;
  }

  const pascalCaseName = changeCase.pascalCase(moduleName);
  try {
    await generateModuleCode(moduleName, targetDirectory);
    window.showInformationMessage(
      `Successfully Generated ${pascalCaseName} Module`
    );
  } catch (error) {
    window.showErrorMessage(
      `Error:
        ${error instanceof Error ? error.message : JSON.stringify(error)}`
    );
  }
};

function promptForModuleName(): Thenable<string | undefined> {
  const moduleNamePromptOptions: InputBoxOptions = {
    prompt: "Module Name",
    placeHolder: "counter",
  };
  return window.showInputBox(moduleNamePromptOptions);
}

async function promptForTargetDirectory(): Promise<string | undefined> {
  const options: OpenDialogOptions = {
    canSelectMany: false,
    openLabel: "Select a folder to create the module in",
    canSelectFolders: true,
  };

  return window.showOpenDialog(options).then((uri) => {
    if (_.isNil(uri) || _.isEmpty(uri)) {
      return undefined;
    }
    return uri[0].fsPath;
  });
}

async function generateModuleCode(
  moduleName: string,
  targetDirectory: string
) {
  const shouldCreateDirectory = workspace
    .getConfiguration("flutter-super")
    .get<boolean>("newModuleTemplate.createDirectory");
  const moduleDirectoryPath = shouldCreateDirectory
    ? `${targetDirectory}/${moduleName}`
    : targetDirectory;
  if (!existsSync(moduleDirectoryPath)) {
    await createDirectory(moduleDirectoryPath);
  }

  await Promise.all([
    createModuleViewTemplate(moduleName, moduleDirectoryPath),
    createModuleControllerTemplate(moduleName, moduleDirectoryPath),
    createModuleTemplate(moduleName, moduleDirectoryPath),
  ]);
}

function createDirectory(targetDirectory: string): Promise<void> {
  return new Promise((resolve, reject) => {
    mkdirp(targetDirectory, (error) => {
      if (error) {
        return reject(error);
      }
      resolve();
    });
  });
}

async function createModuleViewTemplate(
  moduleName: string,
  targetDirectory: string
) {
  const snakeCaseName = changeCase.snakeCase(moduleName);
  const viewsPath = `${targetDirectory}/views`;
  const targetPath = `${viewsPath}/${snakeCaseName}_view.dart`;
  if (existsSync(targetPath)) {
    throw Error(`${snakeCaseName}_view.dart already exists`);
  }
  if (!existsSync(viewsPath)) {
    await createDirectory(viewsPath);
  }
  return new Promise<void>(async (resolve, reject) => {
    writeFile(
      targetPath,
      getModuleViewTemplate(moduleName),
      "utf8",
      (error) => {
        if (error) {
          reject(error);
          return;
        }
        resolve();
      }
    );
  });
}

async function createModuleControllerTemplate(
  moduleName: string,
  targetDirectory: string
) {
  const snakeCaseName = changeCase.snakeCase(moduleName);
  const controllersPath = `${targetDirectory}/controllers`;
  const targetPath = `${controllersPath}/${snakeCaseName}_controller.dart`;
  if (existsSync(targetPath)) {
    throw Error(`${snakeCaseName}_controller.dart already exists`);
  }
  if (!existsSync(controllersPath)) {
    await createDirectory(controllersPath);
  }
  return new Promise<void>(async (resolve, reject) => {
    writeFile(
      targetPath,
      getModuleControllerTemplate(moduleName),
      "utf8",
      (error) => {
        if (error) {
          reject(error);
          return;
        }
        resolve();
      }
    );
  });
}

function createModuleTemplate(
  moduleName: string,
  targetDirectory: string
) {
  const snakeCaseName = changeCase.snakeCase(moduleName);
  const targetPath = `${targetDirectory}/${snakeCaseName}.dart`;
  if (existsSync(targetPath)) {
    throw Error(`${snakeCaseName}.dart already exists`);
  }
  return new Promise<void>(async (resolve, reject) => {
    writeFile(targetPath, getModuleTemplate(moduleName), "utf8", (error) => {
      if (error) {
        reject(error);
        return;
      }
      resolve();
    });
  });
}

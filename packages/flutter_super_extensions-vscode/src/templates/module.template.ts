import * as changeCase from "change-case";

export function getModuleTemplate(moduleName: string) {
  const snakeCaseName = changeCase.snakeCase(moduleName);
  return `export 'controllers/${snakeCaseName}_controller.dart';
export 'views/${snakeCaseName}_view.dart';`;
}


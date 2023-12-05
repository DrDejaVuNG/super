import * as changeCase from "change-case";

export function getModuleControllerTemplate(moduleName: string): string {
  const pascalCaseName = changeCase.pascalCase(moduleName);
  const camelCaseName = changeCase.camelCase(moduleName);
  return `import 'package:flutter_super/flutter_super.dart';
  
final ${camelCaseName}Controller = Super.init(${pascalCaseName}Controller());

class ${pascalCaseName}Controller extends SuperController {
  @override
  void onEnable() {
    super.onEnable();
    // TODO: implement onEnable
  }
  
  @override
  void onAlive() {
    // TODO: implement onAlive
  }
  
  @override
  void onDisable() {
    // TODO: implement onDisable
    super.onDisable();
  }
}`;
}

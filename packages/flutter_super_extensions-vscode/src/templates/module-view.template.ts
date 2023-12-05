import * as changeCase from "change-case";

export function getModuleViewTemplate(moduleName: string): string {
  const pascalCaseName = changeCase.pascalCase(moduleName);
  const camelCaseName = changeCase.camelCase(moduleName);
  return `import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

import '../${camelCaseName}.dart';

class ${pascalCaseName}View extends SuperWidget<${pascalCaseName}Controller> {
  const ${pascalCaseName}View({super.key});

  @override
  ${pascalCaseName}Controller initController() => ${camelCaseName}Controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}`;
}
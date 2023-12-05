import * as _ from "lodash";
import * as semver from "semver";
import { window } from "vscode";
// import { window, env, Uri } from "vscode";
import { getLatestPackageVersion, getPubspecLock } from ".";
import { updatePubspecDependency } from "./update-pubspec-dependency";

const DEFAULT_VERSION_VALUE = "0.0.0";

interface Dependency {
  name: string;
  version: string;
  actions: Action[];
}

interface Action {
  name: string;
  callback: Function;
}

const openSuperMigrationGuide = {
  name: "Open Migration Guide",
  callback: () => {
    // env.openExternal(Uri.parse(""));
  },
};

const deps = [
  { name: "dart_super", actions: [openSuperMigrationGuide] },
  { name: "flutter_super", actions: [openSuperMigrationGuide] },
];

const devDeps = [{ name: "super_test", actions: [openSuperMigrationGuide] }];

export async function analyzeDependencies() {
  const dependencies = await getDependencies(deps);
  const devDependencies = await getDependencies(devDeps);
  const pubspecLock = await getPubspecLock();

  const pubspecLockDependencies = _.get(pubspecLock, "packages", {});

  checkForUpgrades(dependencies, pubspecLockDependencies);
  checkForUpgrades(devDependencies, pubspecLockDependencies);
}

function checkForUpgrades(
  dependencies: Dependency[],
  pubspecDependencies: object[]
) {
  for (let i = 0; i < dependencies.length; i++) {
    const dependency = dependencies[i];
    if (_.isEmpty(dependency.version)) continue;
    if (_.has(pubspecDependencies, dependency.name)) {
      const currentDependencyVersion = _.get(
        pubspecDependencies,
        dependency.name,
      ).version;
      
      const hasLatestVersion = currentDependencyVersion === dependency.version;
      if (hasLatestVersion) continue;
      
      showUpdateMessage(dependency, currentDependencyVersion);
    }
  }
}

function showUpdateMessage(dependency : Dependency, dependencyVersion : string) {
  const minVersion = _.get(
    semver.minVersion(dependencyVersion),
    "version",
    DEFAULT_VERSION_VALUE
  );
  
  if (!semver.satisfies(minVersion, dependency.version)) {
    window
      .showWarningMessage(
        `This workspace contains an outdated version of ${dependency.name}. Please update to ${dependency.version}.`,
        ...['Update']
        // ...dependency.actions.map((action) => action.name).concat("Update")
      )
      .then((invokedAction) => {
        if (invokedAction === "Update") {
          return updatePubspecDependency({
            name: dependency.name,
            latestVersion: `^${dependency.version}`,
            currentVersion: dependencyVersion,
          });
        }
        const action = dependency.actions.find(
          (action) => action.name === invokedAction
        );
        if (!_.isNil(action)) {
          action.callback();
        }
      });
  }
}

async function getDependencies(
  dependencies: { name: string; actions: Action[] }[]
): Promise<Dependency[]> {
  const futures: Promise<Dependency>[] = dependencies.map(
    async (dependency) => {
      return {
        name: dependency.name,
        actions: dependency.actions,
        version: await getLatestPackageVersion(dependency.name),
      };
    }
  );

  return Promise.all(futures);
}

import { wrapWith } from "../utils";

const asyncBuilderSnippet = (widget: string) => {
  return `AsyncBuilder(
    builder: (data) {
      return ${widget};
    },
  )`;
};

const superAppSnippet = (widget: string) => {
  return `SuperApp(
    child: ${widget},
  )`;
};

const superBuilderSnippet = (widget: string) => {
  return `SuperBuilder(
    builder: (context) {
      return ${widget};
    },
  )`;
};

const superConsumerSnippet = (widget: string) => {
  return `SuperConsumer(
    rx: \${1:Subject},
    builder: (context, state) {
      return ${widget};
    },
  )`;
};

const superListenerSnippet = (widget: string) => {
  return `SuperListener(
    listen: () => \${1:Subject},
    listener: (context) {
      \${2:// TODO: implement listener}
    },
    child: ${widget},
  )`;
};

export const wrapWithSuperApp = async () => wrapWith(superAppSnippet);
export const wrapWithAsyncBuilder = async () => wrapWith(asyncBuilderSnippet);
export const wrapWithSuperBuilder = async () => wrapWith(superBuilderSnippet);
export const wrapWithSuperConsumer = async () => wrapWith(superConsumerSnippet);
export const wrapWithSuperListener = async () => wrapWith(superListenerSnippet);

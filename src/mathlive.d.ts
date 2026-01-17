/// <reference types="react" />

declare global {
  namespace JSX {
    interface IntrinsicElements {
      'math-field': any;
    }
  }

  interface Window {
    mathVirtualKeyboard: {
      show(): void;
      hide(): void;
      visible: boolean;
    };
  }
}

export {};

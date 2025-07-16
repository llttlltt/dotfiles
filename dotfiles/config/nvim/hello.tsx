const alphabet: string[] = ["a", "b", "c", "d", "e", "f"];

const join = (string: string[]) => {
  string.map((letter) => letter.trim());
};

function barFunc(foo?: boolean) {
  if (foo) {
    return false;
  } else if (foo === undefined) {
    return undefined;
  }
}

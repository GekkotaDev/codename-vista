// export const loop =
//   <T, U>(callback: (initial: U, self: typeof callback) => T) =>
//   (value: U) =>
//     callback(value, callback);

export const loop =
  <TInitial>(initial: TInitial) =>
  <TResult>(callback: (value: TInitial, _: typeof callback) => TResult): TResult =>
    callback(initial, callback);

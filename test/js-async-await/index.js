function sleep (ms) {
  return new Promise((resolve, reject) => {
    setTimeout(() => resolve(), ms);
  });
}

export default async (input) => {
  await sleep(100);
  return input * 2;
}

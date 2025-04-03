test("Hello", () => {
  let result = global.pyodide.runPython(`
    from boostpython_pyodide import hello_ext
    hello_ext.greet()
  `);
});

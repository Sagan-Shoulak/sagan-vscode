"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { spawnSync } = require("node:child_process");
const { runTests } = require("@vscode/test-electron");

function verifyPackagedDemo(extensionDevelopmentPath, compilerPath) {
  const demoPath = path.join(extensionDevelopmentPath, "examples", "demo.sagan");
  const result = spawnSync(compilerPath, ["--diagnostics-json", demoPath], {
    encoding: "utf8"
  });
  if (result.status !== 0) {
    throw new Error(`Bundled demo failed compiler validation:\n${result.stdout}${result.stderr}`);
  }

  const report = JSON.parse(result.stdout);
  if (report.state !== "complete" || !Array.isArray(report.diagnostics) || report.diagnostics.length !== 0) {
    throw new Error(`Bundled demo is not diagnostic-free: ${result.stdout}`);
  }
}

async function main() {
  const extensionDevelopmentPath = path.resolve(__dirname, "..", "..");
  const serverPath = process.env.SAGAN_LSP_PATH;
  const compilerPath = process.env.SAGAN_COMPILER_PATH;
  if (!serverPath || !fs.existsSync(serverPath)) {
    throw new Error(`Set SAGAN_LSP_PATH to an existing language-server executable: ${serverPath || "<unset>"}`);
  }
  if (!compilerPath || !fs.existsSync(compilerPath)) {
    throw new Error(`Set SAGAN_COMPILER_PATH to an existing compiler executable: ${compilerPath || "<unset>"}`);
  }

  verifyPackagedDemo(extensionDevelopmentPath, compilerPath);

  await runTests({
    extensionDevelopmentPath,
    extensionTestsPath: path.join(__dirname, "suite.js"),
    launchArgs: [path.join(__dirname, "workspace"), "--disable-extensions"],
    extensionTestsEnv: { SAGAN_LSP_PATH: serverPath },
    version: process.env.VSCODE_TEST_VERSION || "stable"
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

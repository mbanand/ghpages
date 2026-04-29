const { execSync } = require("node:child_process");
const { createRequire } = require("node:module");
const path = require("node:path");

function loadPlaywrightTest() {
  try {
    return require("@playwright/test");
  } catch (error) {
    const globalRoot = execSync("npm root -g", { encoding: "utf8" }).trim();
    const globalRequire = createRequire(
      path.join(globalRoot, "@playwright/test", "package.json")
    );
    return globalRequire("@playwright/test");
  }
}

const { test, expect } = loadPlaywrightTest();

test("iris workbench renders and responds", async ({ page }) => {
  test.setTimeout(120000);

  await page.goto("http://127.0.0.1:8765/index.html");

  const app = page.frameLocator("iframe.app-frame");
  await expect(
    app.getByText("Polished analytics with shiny.webawesome")
  ).toBeVisible({
    timeout: 90000,
  });
  await expect(
    app.getByText("Powered by Shinylive: A compact iris workbench")
  ).toBeVisible();
  await expect(app.getByText("Chart", { exact: true })).toBeVisible();
  await expect(app.getByText("Summary", { exact: true })).toBeVisible();
  await expect(app.getByText("Details", { exact: true })).toBeVisible();

  await app.getByRole("radio", { name: "Petal" }).click();
  await expect(app.getByText("Petal.Length vs Petal.Width")).toBeVisible({
    timeout: 10000,
  });

  await app.getByText("Open inspector").click();
  await expect(app.getByText("Current view", { exact: true })).toBeVisible();
  await expect(app.getByText("Species: All species")).toBeVisible();

  await page.screenshot({
    path: "playwright-shinylivepost-clicked.png",
    fullPage: true,
  });
});

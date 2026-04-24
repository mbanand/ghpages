const { test, expect } = require("@playwright/test");

test("iris workbench renders and responds", async ({ page }) => {
  test.setTimeout(120000);

  await page.goto("http://127.0.0.1:8765/index.html");

  const app = page.frameLocator("iframe.app-frame");
  await expect(app.getByText("Iris Workbench")).toBeVisible({
    timeout: 90000,
  });
  await expect(app.getByText("Chart")).toBeVisible();
  await expect(app.getByText("Summary")).toBeVisible();
  await expect(app.getByText("Details")).toBeVisible();

  await app.getByText("Petal preset").click();
  await expect(app.getByText("Petal.Length vs Petal.Width")).toBeVisible();

  await app.getByText("Open inspector").click();
  await expect(app.getByText("Current view")).toBeVisible();
  await expect(app.getByText("Species: All species")).toBeVisible();

  await page.screenshot({
    path: "playwright-shinylivepost-clicked.png",
    fullPage: true,
  });
});

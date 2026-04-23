const { test, expect } = require("@playwright/test");

test("minimal shiny.webawesome Shinylive app renders and responds", async ({ page }) => {
  test.setTimeout(120000);

  await page.goto("http://127.0.0.1:8765/index.html");

  const app = page.frameLocator("iframe.app-frame");
  await expect(app.getByText("Web Awesome, from Shiny")).toBeVisible({
    timeout: 90000,
  });
  await expect(app.getByText("Waiting for a click.")).toBeVisible();

  await app.getByText("Click the Web Awesome button").click();
  await expect(
    app.getByText("Shiny received the Web Awesome button action.")
  ).toBeVisible();

  await page.screenshot({
    path: "playwright-shinylivepost-clicked.png",
    fullPage: true,
  });
});


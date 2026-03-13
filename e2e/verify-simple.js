// Simple Playwright verification script using chromium
// Run with: PLAYWRIGHT_BROWSERS_PATH=/tmp/pw-browsers node e2e/verify-simple.js

const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

const BASE_URL = 'http://localhost:8080';
const SCREENSHOT_DIR = path.join(__dirname, 'screenshots');

async function main() {
  fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });
  
  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox'],
  });
  
  const context = await browser.newContext({
    viewport: { width: 400, height: 800 },
  });
  
  const page = await context.newPage();
  
  try {
    console.log('Loading app...');
    await page.goto(BASE_URL);
    await page.waitForTimeout(8000);
    
    const w = 400, h = 800;
    
    // 1. Welcome screen
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-01-welcome.png') });
    console.log('[1] Welcome screen captured');
    
    // 2. Click "Begin Your Journey" -> Body Info
    await page.mouse.click(w / 2, h * 0.68);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-02-body-info.png') });
    console.log('[2] Body info page captured');
    
    // 3. Click "Continue" -> Mode Select
    await page.mouse.click(w / 2, h * 0.85);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-03-mode-select.png') });
    console.log('[3] Mode select page captured');
    
    // 4. Click "Continue" -> Bench Press
    await page.mouse.click(w / 2, h * 0.88);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-04-bench-press.png') });
    console.log('[4] Bench press input captured');
    
    // 5. Click "Next" -> Row
    await page.mouse.click(w / 2, h * 0.88);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-05-barbell-row.png') });
    console.log('[5] Barbell row input captured');
    
    // 6-7. Continue through Squat, OHP
    await page.mouse.click(w / 2, h * 0.88);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-06-squat.png') });
    console.log('[6] Squat input captured');
    
    await page.mouse.click(w / 2, h * 0.88);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-07-ohp.png') });
    console.log('[7] OHP input captured');
    
    // 8. Adjust All
    await page.mouse.click(w / 2, h * 0.88);
    await page.waitForTimeout(2000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'final-08-adjust-all.png') });
    console.log('[8] Adjust all page captured');
    
    console.log('\nAll screenshots captured successfully!');
    console.log('Screenshots saved to:', SCREENSHOT_DIR);
    
  } catch (err) {
    console.error('Error:', err.message);
  } finally {
    await browser.close();
  }
}

main();

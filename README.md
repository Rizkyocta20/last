# PopByte HPP App (Flutter)
Offline Android app to manage Ingredients, Recipes/BOM, Overhead, Daily Sales, and auto-calc HPP + recommended price (+10% error, +60% profit, +12% tax).

## Phone-only guide to get an APK (no PC)
1. Install the **GitHub** app (Android) and **sign in**.
2. In the GitHub app or mobile web, **create a new repository** (Public or Private). Name it: `PopByteHPPApp`.
3. **Upload** the ZIP from ChatGPT to the repo (click **Add file → Upload files**).
4. After the ZIP is uploaded, in the repo root, click the **three dots → Add file → Create new file** (skip if already visible).
   - Confirm that the folder `.github/workflows/flutter-android.yml` exists (it should be in this project already).
5. Go to the **Actions** tab → Enable workflows for this repo if prompted.
6. Trigger a build: push any small change (e.g., edit README and commit) or tap **Run workflow** if available.
7. Open **Actions → latest run → Artifacts → PopByteHPP-debug-apk** and **download** `app-debug.apk`.
8. Install the APK on your phone (allow install from unknown sources).

> If Actions fail the first time due to dependencies caching, re-run the job; usually the second run succeeds.

## Local usage
- Add ingredients first, then create products and add recipe lines.
- Fill monthly overhead items (rent, wages, utilities, ads tax, etc.).
- Input Daily Sales per product and date.
- Check **HPP Summary** for recommended selling price and daily revenue snapshot.

### Notes & Assumptions
- Price/unit conversion: the app currently treats price per UoI as your chosen "base unit price". If your UoI is "1 kg" and your recipe UoM is in grams, **convert the price to per-gram** before input (e.g., Rp 45.000/kg → Rp 45/gram).
- Overhead allocation: dashboard shows daily overhead (monthly / 30) as context; future update can allocate overhead per-product using target mix.
- You can adjust markup/percentages directly in code later if you want different rates.


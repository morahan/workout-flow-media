# Workout Flow App pricing authority

Owner-confirmed **2026-10-29**. Standard **USD** catalog for agent guidance and marketing. This supersedes older regular-price, trial, and Lifetime notes; it is not a live provider readback. Free remains a separate $0 tier, not a replacement name for Starter.

### Premium

| | Weekly | Monthly | Annual |
| --- | --- | --- | --- |
| Price | $15.99/wk | $39.99/mo | $399.99/yr |
| Free trial | none | 7 days | 7 days |
| Cost for a full year | $831.48 | $479.88 | $399.99 |
| Per month equivalent | $69.29 | $39.99 | $33.33 |
| Per week equivalent | $15.99 | $9.23 | $7.69 |
| % off vs weekly | baseline | 42% off | 52% off |

### Basic

| | Weekly | Monthly | Annual |
| --- | --- | --- | --- |
| Price | $7.99/wk | $19.99/mo | $199.99/yr |
| Free trial | none | 7 days | 7 days |
| Cost for a full year | $415.48 | $239.88 | $199.99 |
| Per month equivalent | $34.62 | $19.99 | $16.67 |
| Per week equivalent | $7.99 | $4.61 | $3.85 |
| % off vs weekly | baseline | 42% off | 52% off |

### Starter

| | Weekly | Monthly | Annual |
| --- | --- | --- | --- |
| Price | $3.99/wk | $9.99/mo | $94/yr |
| Free trial | none | 7 days | 7 days |
| Cost for a full year | $207.48 | $119.88 | $94 |
| Per month equivalent | $17.29 | $9.99 | $7.83 |
| Per week equivalent | $3.99 | $2.31 | $1.81 |
| % off vs weekly | baseline | 42% off | 55% off |

## Lifetime

**Starter only: $299.99 one-time**, no renewal and no free trial. Basic and Premium Lifetime are not current offers. Preserve legacy owners' entitlements and receipt/product mappings; never advertise retired Lifetime products for new purchases.

## Billing and truthful comparisons

- Weekly plans have **no free trial**. Monthly and annual plans on all three paid tiers offer **7 days free if eligible**. Eligibility and the checkout's actual terms govern an individual purchase.
- The Price row is the recurring billed amount and cadence. Monthly/weekly equivalents are comparison figures, not installment options or amounts charged at that cadence. Keep the actual billed total, renewal cadence and trial eligibility adjacent to any equivalent headline. For example: **$7.69/week equivalent, billed $399.99/year after a 7-day trial if eligible**.
- “Cost for a full year” means an **annualized regular-price comparison**, using 52 weekly charges, 12 monthly charges or one annual charge. It is not a forecast of the customer's first calendar year, and excludes trial effects, taxes, promotions and prorations.
- Divide annualized cost by 12 for the monthly equivalent or by 52 for the weekly equivalent. Calculate from unrounded catalog amounts; round displayed currency to two decimals.
- Savings vs weekly = `round(100 × (1 − annualized plan cost / (weekly price × 52)))`. The owner's “% off vs weekly” table shorthand means a billing-cadence comparison. Customer-facing wording is **“Save N% vs weekly”**, not a sale, a former “Was” price or a discount versus monthly. State the 52-week basis in supporting text/accessibility copy.
- Use a weekly savings comparison only when that tier's weekly plan is actually purchasable on the relevant rail. Do not mix it with a seasonal-sale anchor. Discounts need separate current approval and provider evidence; historical campaign notes do not authorize an offer.
- Native storefronts may use localized currencies/prices. Show provider-returned localized amounts and recompute comparisons in the same currency; never attach the USD percentage to different localized prices without checking the math.

## Superwall screen presentation (owner direction, 2026-10-29)

- Show **at most three price figures on one screen**. Default to a label-only two-duration toggle, **Weekly/Annual or Weekly/Monthly**. A Weekly/Monthly/Annual toggle is allowed when necessary, but only the selected plan’s pricing details appear; the toggle updates one selected-plan panel instead of displaying a grid of prices.
- For monthly/annual comparisons, the three figures are: the same tier's crossed reference explicitly labeled **“Pay weekly”**, the selected plan's labeled **weekly equivalent**, and the **actual billed total with its billing cadence**. Keep the actual billed total adjacent and prominent. A crossed weekly reference is a cadence comparison, never a former “Was” price. Show the applicable “Save N% vs weekly” statement only under the comparison rules above.
- Weekly shows its actual weekly charge, renewal cadence and **no free trial**, without an invented savings comparison. Monthly/annual show **7 days free if eligible**, then the actual charge and renewal cadence; trial CTA and disclosures must follow the selected product and verified eligibility. Preserve an explicitly selected plan when arriving through a plan-specific purchase path; do not silently switch its tier or cadence.
- A **Premium-only screen contains only Premium** benefits and products, with no Basic or Starter offers. A generic selector may use a label-only tier switch; switching it must update the benefits, selected product, prices, trial disclosure and purchase CTA together. Never show a nine-price tier-by-cadence grid.
- **Feature gates are tier-only:** separate Starter, Basic and Premium paywalls, each with all three Weekly/Monthly/Annual labels and only the selected plan’s pricing details. Route from the actual feature requirement and validated quota/health context (`required_tier`, `trigger_feature`, `trigger_screen`, `source_placement`); preserve explicit plan selection (`selected_plan`, `selected_tier`, `selected_term`). These fields select presentation, never grant entitlement. Basic features remain available to qualifying Basic and Premium members.
- Every Superwall paywall uses the **Workout Flow App logo and brand blue**, with **no purple** treatment. Verify the actual live creative; this document does not publish it.
- This direction applies to Superwall screens, including the owner's review of paywall **276425**. It does not replace the separately approved app-native onboarding sequence. Documentation is not proof that the live paywall has been updated or published.

## Authority and maintenance

This owner decision governs the intended standard catalog. The main app's `src/constants/planRegistry.ts` implements it; `docs/subscriptions/PRICING.md` in that repository retains entitlement, product-mapping and dated rollout evidence. A code/provider mismatch is a discrepancy to report and reconcile, not permission to change this decision silently or advertise a price checkout cannot honor.

Before publishing an offer, verify the relevant product, price, trial eligibility and availability in the actual checkout/store/provider. This documentation update changes no runtime code, deployed checkout, provider setting or campaign. Older audits, receipt aliases, competitor research, screenshots and dated readbacks remain historical evidence, never current sales authority.

For a complete comparison of the **three paid tiers**, use Premium → Basic → Starter; preserve a visible Free continuation option where supported. A four-tier comparison is Premium → Basic → Starter → Free. This does not replace an explicitly approved surface-specific onboarding flow or Premium Annual highlight.

Workspace master: `/2026/PRICING.md`. Each primary repository keeps an identical root `PRICING.md` so isolated clones and agents can read the decision without sibling checkouts. When the owner changes pricing, update the master and all mirrors together, then check agent docs, marketing skills and active offer notes for drift.

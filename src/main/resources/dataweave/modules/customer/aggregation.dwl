%dw 2.0
output application/json
---
{
    customerId: vars.customerId,
    profile: payload."0".payload,
    finance_overview: payload."1".payload,
    generated_at: now()
}
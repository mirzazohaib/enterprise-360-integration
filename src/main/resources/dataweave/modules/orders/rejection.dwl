%dw 2.0
output application/json
---
{
    status: "Rejected",
    reason: "Item is out of stock",
    productId: vars.originalOrder.productId
}
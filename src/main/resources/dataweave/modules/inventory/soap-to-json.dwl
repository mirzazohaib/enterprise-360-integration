%dw 2.0
output application/json
ns ns0 http://warehouse.legacy.com
---
{
    productId: payload.Envelope.Body.ns0#StockResponse.ns0#ProductID,
    quantity: payload.Envelope.Body.ns0#StockResponse.ns0#Quantity as Number,
    status: payload.Envelope.Body.ns0#StockResponse.ns0#Status,
    source: "Legacy SOAP System (Dynamic Mock)"
}
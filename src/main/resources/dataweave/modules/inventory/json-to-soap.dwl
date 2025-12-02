%dw 2.0
output application/xml
ns soapenv http://schemas.xmlsoap.org/soap/envelope/
ns inv http://warehouse.legacy.com
---
{
    soapenv#Envelope: {
        soapenv#Body: {
            inv#StockRequest: {
                inv#ProductId: payload.productId,
                inv#RequestDate: now() as String {format: "yyyy-MM-dd"}
            }
        }
    }
}
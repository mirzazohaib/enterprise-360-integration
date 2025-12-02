%dw 2.0
output application/xml
ns soapenv http://schemas.xmlsoap.org/soap/envelope/
ns inv http://warehouse.legacy.com
---
{
    soapenv#Envelope: {
        soapenv#Body: {
            inv#StockResponse: {
                inv#ProductID: vars.requestedId,
                inv#Quantity: if (vars.requestedId == "P-999") 0 else 500,
                inv#Status: if (vars.requestedId == "P-999") "OUT_OF_STOCK" else "IN_STOCK"
            }
        }
    }
}
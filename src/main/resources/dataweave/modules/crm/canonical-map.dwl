%dw 2.0
output application/json
---
{
    customerId: payload.data.id,
    fullName: (payload.data.first_name as String) ++ " " ++ (payload.data.last_name as String),
    email: payload.data.email,
    tier: "Gold", 
    source: "External CRM (REST)"
}
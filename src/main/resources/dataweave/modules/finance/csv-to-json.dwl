%dw 2.0
output application/json
---
(payload as Array) map (record, index) -> {
    transactionId: record.Tx_ID,
    amount: record.Amount as Number,
    date: record.Date,
    description: record.Description,
    source: "Finance SFTP Server"
}
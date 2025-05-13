USE pulse_uni_db;

SELECT
    f.festival_id,
    YEAR(f.date_starting) AS Festival_Year,

    -- Conditional SUMs for each payment method
    SUM(CASE WHEN pm.payment_method = 'Credit Card' THEN t.cost ELSE 0 END) AS Credit_Card,
    SUM(CASE WHEN pm.payment_method = 'Debit Card' THEN t.cost ELSE 0 END) AS Debit_Card,
    SUM(CASE WHEN pm.payment_method = 'Bank Transfer' THEN t.cost ELSE 0 END) AS Bank_Transfer,
    SUM(CASE WHEN pm.payment_method = 'Mobile Wallet' THEN t.cost ELSE 0 END) AS Mobile_Wallet,
    SUM(CASE WHEN pm.payment_method = 'Online Banking' THEN t.cost ELSE 0 END) AS Online_Banking,
    SUM(CASE WHEN pm.payment_method = 'Prepaid Card' THEN t.cost ELSE 0 END) AS Prepaid_Card,
    SUM(CASE WHEN pm.payment_method = 'Cash' THEN t.cost ELSE 0 END) AS Cash,

    -- Total of all ticket sales
    SUM(t.cost) AS Total_Income

FROM FESTIVALS f
JOIN FESTIVAL_EVENTS fe ON fe.festival_id = f.festival_id
JOIN TICKETS t ON t.event_id = fe.event_id
JOIN PAYMENT_METHODS pm ON t.payment_method_id = pm.payment_method_id

GROUP BY f.festival_id, YEAR(f.date_starting)
ORDER BY Festival_Year DESC;
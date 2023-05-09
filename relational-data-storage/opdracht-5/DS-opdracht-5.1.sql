--opdracht 5.1.1
SELECT  COUNT(hitcount),
        AVG(hitcount),
        MIN(hitcount),
        MAX(hitcount),
        SUM(hitcount)
FROM    mhl_hitcount


--opdracht 5.1.2
SELECT  COUNT(hitcount),
        AVG(hitcount),
        MIN(hitcount),
        MAX(hitcount),
        SUM(hitcount)
FROM    mhl_hitcount
GROUP BY year


--opdracht 5.1.3
SELECT  COUNT(hitcount),
        AVG(hitcount),
        MIN(hitcount),
        MAX(hitcount),
        SUM(hitcount)
FROM    mhl_hitcount
GROUP BY year, month


--opdracht 5.1.4
SELECT  mhl_suppliers.name,
        SUM(H.hitcount),
        COUNT(H.month),
        ROUND(AVG(H.hitcount),0)
FROM    mhl_hitcount H
JOIN    mhl_suppliers ON H.supplier_ID=mhl_suppliers.ID
GROUP BY mhl_suppliers.name

SELECT
    CR.ReceiptID,
    CR.ReceiptDate,
    P.ParentName,
    CR.ReceiptTotal,
    CCur(Nz(Sum(RA.AppliedAmount), 0)) AS TotalAllocated,
    CCur(CR.ReceiptTotal - Nz(Sum(RA.AppliedAmount), 0)) AS UnappliedOrOverAllocated
FROM (tblCashReceipt AS CR
INNER JOIN tblPetParent AS P ON CR.ParentID = P.ParentID)
LEFT JOIN tblReceiptAllocation AS RA ON CR.ReceiptID = RA.ReceiptID
GROUP BY
    CR.ReceiptID,
    CR.ReceiptDate,
    P.ParentName,
    CR.ReceiptTotal
ORDER BY CR.ReceiptID;

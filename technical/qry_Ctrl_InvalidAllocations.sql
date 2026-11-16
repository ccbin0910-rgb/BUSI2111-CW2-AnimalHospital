SELECT
    'Cross-Parent Allocation' AS ExceptionType,
    'Receipt #' & RA.ReceiptID & ' -> Appt #' & RA.AppointmentID AS RecordRef,
    'Receipt ParentID (' & CR.ParentID & ') <> Pet ParentID (' & T.ParentID & ')' AS Details,
    RA.AppliedAmount AS ExceptionAmount
FROM ((tblReceiptAllocation AS RA
INNER JOIN tblCashReceipt AS CR ON RA.ReceiptID = CR.ReceiptID)
INNER JOIN tblAppointment AS A ON RA.AppointmentID = A.AppointmentID)
INNER JOIN tblPet AS T ON A.PetID = T.PetID
WHERE CR.ParentID <> T.ParentID

UNION ALL

SELECT
    'Receipt Over-Allocated' AS ExceptionType,
    'Receipt #' & ReceiptID AS RecordRef,
    'Total allocated exceeds ReceiptTotal' AS Details,
    UnappliedOrOverAllocated AS ExceptionAmount
FROM qry_05_ReceiptReconciliation
WHERE UnappliedOrOverAllocated < 0

UNION ALL

SELECT
    'Appointment Over-Paid' AS ExceptionType,
    'Appointment #' & AppointmentID AS RecordRef,
    'Total cash applied exceeds TotalAppointmentCharge' AS Details,
    OutstandingBalance AS ExceptionAmount
FROM qry_04_AppointmentBalance
WHERE OutstandingBalance < 0;

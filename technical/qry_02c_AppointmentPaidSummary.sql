SELECT
    RA.AppointmentID,
    Sum(RA.AppliedAmount) AS TotalPaid
FROM tblReceiptAllocation AS RA
GROUP BY RA.AppointmentID;

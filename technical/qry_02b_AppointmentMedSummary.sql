SELECT
    PL.AppointmentID,
    Sum(PL.Quantity * PL.UnitPriceCharged) AS TotalMedCharge
FROM tblPrescriptionLine AS PL
GROUP BY PL.AppointmentID;

SELECT
    PL.AppointmentID,
    PL.MedicationID,
    M.MedicationName,
    M.ListPrice,
    PL.UnitPriceCharged,
    PL.Quantity,
    CCur(PL.Quantity * PL.UnitPriceCharged) AS LineCharge
FROM tblPrescriptionLine AS PL
INNER JOIN tblMedication AS M
    ON PL.MedicationID = M.MedicationID
ORDER BY PL.AppointmentID, PL.MedicationID;

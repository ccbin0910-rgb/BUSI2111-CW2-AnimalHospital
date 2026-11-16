SELECT
    AT.AppointmentID,
    AT.AppointmentDate,
    AT.ParentName,
    AT.PetName,
    AT.AppointmentFee,
    AT.MedicineCharge,
    AT.TotalAppointmentCharge,
    CCur(Nz(PS.TotalPaid, 0)) AS TotalCashApplied,
    CCur(AT.TotalAppointmentCharge - Nz(PS.TotalPaid, 0)) AS OutstandingBalance
FROM qry_03_AppointmentTotal AS AT
LEFT JOIN qry_02c_AppointmentPaidSummary AS PS
    ON AT.AppointmentID = PS.AppointmentID
ORDER BY AT.AppointmentID;

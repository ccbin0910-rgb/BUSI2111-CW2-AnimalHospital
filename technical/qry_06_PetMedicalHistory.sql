SELECT
    T.PetID,
    T.PetName,
    T.Breed,
    P.ParentName,
    A.AppointmentID,
    A.AppointmentDate,
    V.VetName,
    A.WeightKg,
    A.VisitReason,
    A.Diagnosis,
    M.MedicationName,
    PL.Quantity,
    PL.UnitPriceCharged
FROM ((((tblPet AS T
INNER JOIN tblPetParent AS P ON T.ParentID = P.ParentID)
INNER JOIN tblAppointment AS A ON T.PetID = A.PetID)
INNER JOIN tblVeterinarian AS V ON A.VetID = V.VetID)
LEFT JOIN tblPrescriptionLine AS PL ON A.AppointmentID = PL.AppointmentID)
LEFT JOIN tblMedication AS M ON PL.MedicationID = M.MedicationID
ORDER BY T.PetID, A.AppointmentDate DESC;

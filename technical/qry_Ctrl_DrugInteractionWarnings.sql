SELECT
    P1.AppointmentID,
    A.AppointmentDate,
    T.PetName,
    M1.MedicationName AS MedicationA,
    M2.MedicationName AS MedicationB,
    MI.SeverityLevel,
    MI.InteractionDescription
FROM (((((tblPrescriptionLine AS P1
INNER JOIN tblPrescriptionLine AS P2
    ON P1.AppointmentID = P2.AppointmentID)
INNER JOIN tblMedicationInteraction AS MI
    ON (P1.MedicationID = MI.MedicationAID) AND (P2.MedicationID = MI.MedicationBID))
INNER JOIN tblMedication AS M1
    ON P1.MedicationID = M1.MedicationID)
INNER JOIN tblMedication AS M2
    ON P2.MedicationID = M2.MedicationID)
INNER JOIN tblAppointment AS A
    ON P1.AppointmentID = A.AppointmentID)
INNER JOIN tblPet AS T
    ON A.PetID = T.PetID
WHERE P1.MedicationID < P2.MedicationID
ORDER BY P1.AppointmentID;

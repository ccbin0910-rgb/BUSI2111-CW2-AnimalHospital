SELECT
    A.AppointmentID,
    A.AppointmentDate,
    P.ParentName,
    T.PetName,
    V.VetName,
    A.AppointmentFee,
    CCur(Nz(M.TotalMedCharge, 0)) AS MedicineCharge,
    CCur(A.AppointmentFee + Nz(M.TotalMedCharge, 0)) AS TotalAppointmentCharge
FROM (((tblAppointment AS A
INNER JOIN tblPet AS T ON A.PetID = T.PetID)
INNER JOIN tblPetParent AS P ON T.ParentID = P.ParentID)
INNER JOIN tblVeterinarian AS V ON A.VetID = V.VetID)
LEFT JOIN qry_02b_AppointmentMedSummary AS M ON A.AppointmentID = M.AppointmentID
ORDER BY A.AppointmentID;

SELECT A.AppointmentID, T.ParentID
FROM tblAppointment AS A INNER JOIN tblPet AS T ON A.PetID=T.PetID;

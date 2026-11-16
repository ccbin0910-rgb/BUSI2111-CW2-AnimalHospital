SELECT
    P.ParentID,
    P.ParentName,
    P.DayPhone,
    Count(T.PetID) AS NumberOfPets
FROM tblPetParent AS P
LEFT JOIN tblPet AS T
    ON P.ParentID = T.ParentID
GROUP BY
    P.ParentID,
    P.ParentName,
    P.DayPhone
ORDER BY P.ParentID;

# UNNC Animal Hospital — REA assumptions

## Scope and business rules

1. Medication quantities represent whole packages. The prescription line retains the unit price charged on the visit date so that later catalogue price changes do not alter historical charges.
2. An Appointment represents a completed clinical visit. Each visit involves one pet and one veterinarian and may involve zero or more medications. Future bookings are outside scope.
3. A receipt comes from one pet parent and enters one cash account. Payments may be split across visits, and a visit may be settled by several receipts. An unallocated receipt or unpaid visit is permitted. Each allocation must belong to the same parent as the visit.
4. **D3 — confirmed by the group.** Every cash receipt must identify exactly one collecting veterinarian. A veterinarian may collect zero or more receipts. The collector may differ from the treating veterinarian. In Access, tblCashReceipt.CollectedByVetID is a required foreign key referencing tblVeterinarian.VetID.
5. Each pet has one current registered parent. The parent billed for a visit is derived through the pet. The design does not preserve ownership history, so changing the registered parent after a visit would change the apparent owner of the historical bill.

## How to read the diagram

The bar at an endpoint means exactly one. A circle and crow’s foot mean zero or many. The triangle indicates the direction in which to read the verb. Pet is the service recipient. Medication and CashAccount are resources, Appointment and CashReceipt are events, and Veterinarian and PetParent are agents.

| Relationship | For one entity at each end |
|---|---|
| Veterinarian performs Appointment | A veterinarian may perform many visits. Each visit has one treating veterinarian. |
| Pet attends Appointment | A pet may attend many visits. Each visit concerns one pet. |
| PetParent owns Pet | A parent may have zero or many pets. Each pet has one current registered parent. |
| PetParent is billed for Appointment, via Pet | A parent may be billed for many visits. Each visit has one parent derived through Pet. |
| Medication is prescribed in Appointment | A medication may appear in many visits. A visit may include many medications or none. |
| Medication interacts with Medication | A medication may interact with zero or many other medications. A pair is recorded once, with two distinct medications. |
| Appointment is settled by CashReceipt | A visit may receive zero or many payments. A receipt may be allocated to zero or many visits. |
| CashAccount receives CashReceipt | An account may receive many payments. Each receipt enters one account. |
| PetParent pays CashReceipt | A parent may make many payments. Each receipt has one payer. |
| Veterinarian collects CashReceipt (D3) | A veterinarian may collect zero or more receipts. Each receipt has one collector. |

In Access, PrescriptionLine, ReceiptAllocation and MedicationInteraction implement the three many-to-many relationships. The conceptual diagram shows those relationships directly.

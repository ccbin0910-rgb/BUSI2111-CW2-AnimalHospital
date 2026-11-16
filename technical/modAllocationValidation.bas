Attribute VB_Name = "modAllocationValidation"
Option Compare Database
Option Explicit

'Pre-save helper, not a database-wide constraint or a concurrency lock.
'Null originals mean insert; both non-Null originals mean edit of the same pair.
Public Function AllocationIssue(ByVal receiptId As Variant, ByVal appointmentId As Variant, _
    ByVal applied As Variant, ByVal originalReceiptId As Variant, _
    ByVal originalAppointmentId As Variant) As String
    On Error GoTo Failed
    Dim rp As Variant, ap As Variant, rt As Variant, atotal As Variant
    Dim rc As String, ac As String, excluded As String
    Dim amount As Currency, rSum As Currency, aSum As Currency
    Dim rid As Long, aid As Long
    AllocationIssue = "Validation did not finish."
    If IsNull(receiptId) Or IsNull(appointmentId) Or IsNull(applied) Then
        AllocationIssue = "Select receipt, appointment, and amount.": Exit Function
    End If
    If Not IsNumeric(receiptId) Or Not IsNumeric(appointmentId) Or Not IsNumeric(applied) Then
        AllocationIssue = "IDs and amount must be numeric.": Exit Function
    End If
    If receiptId <= 0 Or appointmentId <= 0 Or receiptId <> Fix(receiptId) Or appointmentId <> Fix(appointmentId) Then
        AllocationIssue = "IDs must be positive whole numbers.": Exit Function
    End If
    If CDbl(applied) <= 0 Then
        AllocationIssue = "Applied amount must be positive.": Exit Function
    End If
    amount = CCur(applied)
    If CDec(applied) <> CDec(Round(amount, 2)) Then
        AllocationIssue = "Use at most two decimal places.": Exit Function
    End If
    rid = CLng(receiptId): aid = CLng(appointmentId)
    If IsNull(originalReceiptId) Xor IsNull(originalAppointmentId) Then
        AllocationIssue = "Incomplete original key; reload the record.": Exit Function
    End If
    excluded = ""
    If Not IsNull(originalReceiptId) Then
        If rid <> CLng(originalReceiptId) Or aid <> CLng(originalAppointmentId) Then
            AllocationIssue = "Existing allocation keys cannot be changed; review and replace the allocation.": Exit Function
        End If
        excluded = " AND NOT (ReceiptID=" & rid & " AND AppointmentID=" & aid & ")"
    Else
        If DCount("*", "tblReceiptAllocation", "ReceiptID=" & rid & " AND AppointmentID=" & aid) > 0 Then
            AllocationIssue = "This receipt/appointment pair already exists; edit its amount.": Exit Function
        End If
    End If
    rp = DLookup("ParentID", "tblCashReceipt", "ReceiptID=" & rid)
    ap = DLookup("ParentID", "qry_00_AppointmentOwner", "AppointmentID=" & aid)
    rt = DLookup("ReceiptTotal", "tblCashReceipt", "ReceiptID=" & rid)
    atotal = DLookup("TotalAppointmentCharge", "qry_03_AppointmentTotal", "AppointmentID=" & aid)
    If IsNull(rp) Or IsNull(ap) Or IsNull(rt) Or IsNull(atotal) Then
        AllocationIssue = "Referenced receipt or appointment is missing; save parent records first.": Exit Function
    End If
    If rp <> ap Then
        AllocationIssue = "Cross-parent allocation is not allowed.": Exit Function
    End If
    rc = "ReceiptID=" & rid & excluded
    ac = "AppointmentID=" & aid & excluded
    rSum = CCur(Nz(DSum("AppliedAmount", "tblReceiptAllocation", rc), 0))
    aSum = CCur(Nz(DSum("AppliedAmount", "tblReceiptAllocation", ac), 0))
    If rSum + amount > CCur(rt) Then
        AllocationIssue = "Allocation exceeds receipt total.": Exit Function
    End If
    If aSum + amount > CCur(atotal) Then
        AllocationIssue = "Allocation exceeds appointment charge.": Exit Function
    End If
    AllocationIssue = ""
    Exit Function
Failed:
    AllocationIssue = "Validation failed (" & Err.Number & "): " & Err.Description
End Function

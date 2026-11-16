from pathlib import Path
import json, datetime, traceback
import pythoncom, win32com.client

ROOT=Path(__file__).resolve().parent.parent
run=ROOT/'technical'/('run_'+datetime.datetime.now().strftime('%Y%m%d_%H%M%S'))
run.mkdir()
spec=json.loads((ROOT/'technical/spec.json').read_text(encoding='utf-8-sig'))
log={'scope':'Real Microsoft Access COM / DAO database and optional VBA helper tests; NOT UI tests or submission approval','database':str(run/'CW2_validation_prototype.accdb'),'started':datetime.datetime.now().isoformat(),'checks':[]}
def check(name,ok,actual=None):
    row=dict(name=name,status='PASS' if ok else 'FAIL',actual=actual)
    log['checks'].append(row)
    print(json.dumps(row,ensure_ascii=False),flush=True)
def save():
    (run/'test_results.json').write_text(json.dumps(log,ensure_ascii=False,indent=2,default=str),encoding='utf-8-sig')
    (ROOT/'technical/latest_run.json').write_text(json.dumps({'run':str(run)},ensure_ascii=False),encoding='utf-8-sig')
app=None
try:
    pythoncom.CoInitialize()
    app=win32com.client.DispatchEx('Access.Application')
    app.Visible=False
    app.NewCurrentDatabase(log['database'])
    log['access_version']=str(app.Version)
    db=app.CurrentDb()
    typemap={'AutoNumber':4,'Number':7,'Currency':5,'Date/Time':8,'Short Text':10}
    money=[]
    for table in spec['tables']:
        td=db.CreateTableDef(table['name'])
        pk=[]
        for field in table['fields']:
            ft=typemap[field['type']]
            if field['type']=='Number' and field['size']=='Long Integer': ft=4
            size=int(field['size']) if ft==10 else 0
            f=td.CreateField(field['name'],ft,size)
            if field['type']=='AutoNumber': f.Attributes=16
            else: f.Required=field['required']
            if ft==10: f.AllowZeroLength=False
            rule=field['rule'] if field['rule']!='-' else ''
            if ft==5: money.append((table['name'],field['name']))
            if rule:
                f.ValidationRule=rule
                f.ValidationText=field['text'] if field['text']!='-' else 'Invalid value.'
            td.Fields.Append(f)
            if 'PK' in field['key']: pk.append(field['name'])
        idx=td.CreateIndex('PrimaryKey')
        idx.Primary=True
        idx.Unique=True
        for name in pk: idx.Fields.Append(idx.CreateField(name))
        td.Indexes.Append(idx)
        if table['name']=='tblMedicationInteraction':
            td.ValidationRule='[MedicationAID]<[MedicationBID]'
            td.ValidationText='MedicationAID must be less than MedicationBID.'
        db.TableDefs.Append(td)
        for field in table['fields']:
            f=db.TableDefs(table['name']).Fields(field['name'])
            f.Properties.Append(f.CreateProperty('Description',10,field['description']))
            if field['type']=='Currency':
                f.Properties.Append(f.CreateProperty('Format',10,'Currency'))
                f.Properties.Append(f.CreateProperty('DecimalPlaces',2,2))
            elif field['type']=='Date/Time':
                f.Properties.Append(f.CreateProperty('Format',10,'Short Date'))
            if 'Indexed' in field['key'] and 'FK' not in field['key']:
                idx=db.TableDefs(table['name']).CreateIndex('ix_'+field['name'])
                idx.Unique=False
                idx.Fields.Append(idx.CreateField(field['name']))
                db.TableDefs(table['name']).Indexes.Append(idx)
    for i,(parent,pk,child,fk) in enumerate(spec['relations']):
        rel=db.CreateRelation('rel_'+str(i+1),parent,child,0)
        f=rel.CreateField(pk)
        f.ForeignName=fk
        rel.Fields.Append(f)
        db.Relations.Append(rel)
    def execute(sql): db.Execute(sql,128)
    def literal(value):
        if isinstance(value,str): return "'"+value.replace("'","''")+"'"
        return str(value)
    def insert(table,fields,values):
        execute('INSERT INTO '+table+' ('+','.join('['+f+']' for f in fields)+') VALUES ('+','.join(literal(v) for v in values)+')')
    inserts=[
      ('tblPetParent',['ParentID','ParentName','Address','DayPhone','EveningPhone'],[
        [1,'Emily Chen','199 Taikang East Road, Ningbo','0574-88180001','13805740001'],[2,'David Wang','88 Qianhu North Road, Ningbo','0574-88180002','13905740002']]),
      ('tblVeterinarian',['VetID','VetName','RoleTitle'],[[1,'Dr. Nottingham','Co-Owner / Lead Veterinarian'],[2,'Dr. Lin','Co-Owner / Veterinarian']]),
      ('tblMedication',['MedicationID','MedicationName','ListPrice'],[[1,'AmoxiVet Oral Suspension',35],[2,'FeliRelief Anti-Inflammatory',25],[3,'GastroCalm Drops',40]]),
      ('tblCashAccount',['AccountID','AccountName','AccountType'],[[1,'Front Desk Cash','Cash'],[2,'Clinic Bank','Bank']]),
    ]
    for table,fields,rows in inserts:
        for row in rows: insert(table,fields,row)
    execute("INSERT INTO tblPet (PetID,ParentID,PetName,Breed,Color,BirthDate) VALUES (1,1,'Mochi','British Shorthair (Cat)','Cream',#2023-04-15#)")
    execute("INSERT INTO tblPet (PetID,ParentID,PetName,Breed,Color,BirthDate) VALUES (2,1,'Boba','Ragdoll (Cat)','Seal Bicolor',#2024-06-20#)")
    execute("INSERT INTO tblAppointment VALUES (1,1,1,#2026-11-10#,30,4.2,'Skin rash and mild fever','Mild bacterial dermatitis',120)")
    execute("INSERT INTO tblAppointment VALUES (2,2,2,#2026-11-12#,20,3.8,'Annual wellness checkup','Healthy; routine exam passed',90)")
    execute("INSERT INTO tblMedicationInteraction VALUES (1,2,'Moderate','Concurrent administration may increase gastrointestinal irritation (fictional sample rule).')")
    execute("INSERT INTO tblMedicationInteraction VALUES (2,3,'High','Avoid co-administration within 4 hours due to reduced absorption (fictional sample rule).')")
    execute('INSERT INTO tblPrescriptionLine VALUES (1,1,2,30)')
    execute('INSERT INTO tblPrescriptionLine VALUES (1,2,1,25)')
    # Use explicit columns; blueprint order differs from relationship order.
    execute('INSERT INTO tblCashReceipt (ReceiptID,ParentID,AccountID,CollectedByVetID,ReceiptDate,ReceiptTotal) VALUES (1,1,1,1,#2026-11-10#,100)')
    execute('INSERT INTO tblCashReceipt (ReceiptID,ParentID,AccountID,CollectedByVetID,ReceiptDate,ReceiptTotal) VALUES (2,1,2,2,#2026-11-14#,105)')
    execute('INSERT INTO tblReceiptAllocation VALUES (1,1,100)')
    execute('INSERT INTO tblReceiptAllocation VALUES (2,1,105)')
    for name,sql in spec['queries'].items():
        db.CreateQueryDef(name,sql)
    def rows(sql):
        rs=db.OpenRecordset(sql)
        result=[]
        while not rs.EOF:
            row={}
            for i in range(rs.Fields.Count):
                f=rs.Fields(i)
                try: row[f.Name]=f.Value
                except Exception as e: raise RuntimeError(f'{sql} row {len(result)+1} field {f.Name}: {e}')
            result.append(row)
            rs.MoveNext()
        rs.Close()
        return result
    def scalar(sql): return next(iter(rows(sql)[0].values()))
    check('structure: ten business tables / twelve enforced non-cascade relationships',
          len([t for t in db.TableDefs if not t.Name.startswith('MSys')])==10 and len([r for r in db.Relations if r.Name.startswith('rel_')])==12)
    for name in spec['queries']:
        result=rows(name)
        check('query opens: '+name,True,{'rows':len(result)})
    check('baseline amounts',[(r['AppointmentID'],float(r['TotalAppointmentCharge']),float(r['OutstandingBalance'])) for r in rows('qry_04_AppointmentBalance')]==[(1,205.0,0.0),(2,90.0,90.0)])
    check('parent counts',[(r['ParentID'],r['NumberOfPets']) for r in rows('qry_01_ParentPetCount')]==[(1,2),(2,0)])
    check('baseline anomalies',len(rows('qry_Ctrl_InvalidAllocations'))==0)
    check('fictional drug pair warning',len(rows('qry_Ctrl_DrugInteractionWarnings'))==1)
    # Independent transactions for each operation; roll back both success/failure.
    ws=app.DBEngine.Workspaces(0)
    def reject(name,sql):
        ws.BeginTrans()
        try:
            try:
                execute(sql)
                check(name,False,'Accepted unexpectedly')
            except Exception as e: check(name,True,str(e))
        finally: ws.Rollback()
    reject('T01 negative weight', 'UPDATE tblAppointment SET WeightKg=-2 WHERE AppointmentID=1')
    reject('T01 zero quantity','UPDATE tblPrescriptionLine SET Quantity=0 WHERE AppointmentID=1 AND MedicationID=1')
    reject('T02 fractional quantity','UPDATE tblPrescriptionLine SET Quantity=1.5 WHERE AppointmentID=1 AND MedicationID=1')
    reject('T02 fractional minutes','UPDATE tblAppointment SET DurationMin=1.5 WHERE AppointmentID=1')
    reject('T03 future birth','UPDATE tblPet SET BirthDate=#2099-01-01# WHERE PetID=1')
    reject('T04 invalid pet','UPDATE tblAppointment SET PetID=999 WHERE AppointmentID=1')
    reject('T05 referenced pet delete','DELETE FROM tblPet WHERE PetID=1')
    reject('T06 self pair',"INSERT INTO tblMedicationInteraction VALUES (1,1,'High','Test')")
    reject('T06 reverse pair',"INSERT INTO tblMedicationInteraction VALUES (2,1,'High','Test')")
    reject('T06 duplicate pair',"INSERT INTO tblMedicationInteraction VALUES (1,2,'High','Test')")
    reject('T12 duplicate allocation','INSERT INTO tblReceiptAllocation VALUES (1,1,20)')
    reject('T19 third decimal amount','UPDATE tblCashReceipt SET ReceiptTotal=100.001 WHERE ReceiptID=1')
    reject('T20 invalid account','UPDATE tblCashReceipt SET AccountID=999 WHERE ReceiptID=1')
    reject('T20 invalid collector','UPDATE tblCashReceipt SET CollectedByVetID=999 WHERE ReceiptID=1')
    reject('T20 null account','UPDATE tblCashReceipt SET AccountID=Null WHERE ReceiptID=1')
    reject('blank required name',"UPDATE tblPetParent SET ParentName='' WHERE ParentID=1")
    def scenario(name,sqls,verify):
        ws.BeginTrans()
        try:
            for sql in sqls: execute(sql)
            actual,expected=verify()
            check(name,actual==expected,actual)
        finally: ws.Rollback()
    def newreceipt(parent,amount):
        return f'INSERT INTO tblCashReceipt (ReceiptID,ParentID,AccountID,CollectedByVetID,ReceiptDate,ReceiptTotal) VALUES (3,{parent},1,1,#2026-11-14#,{amount})'
    for label,parent,total,amount,expected in [('T07 isolated cross-parent',2,50,40,'Cross-Parent Allocation'),('T08 isolated receipt excess',1,50,60,'Receipt Over-Allocated'),('T09 isolated appointment excess',1,120,100,'Appointment Over-Paid')]:
        scenario(label,[newreceipt(parent,total),f'INSERT INTO tblReceiptAllocation VALUES (3,2,{amount})'],lambda e=expected:([r['ExceptionType'] for r in rows('qry_Ctrl_InvalidAllocations')],[e]))
    scenario('T10 unallocated receipt',[newreceipt(1,50)],lambda:(float(scalar('SELECT UnappliedOrOverAllocated FROM qry_05_ReceiptReconciliation WHERE ReceiptID=3')),50.0))
    scenario('T10 partially allocated receipt',[newreceipt(1,50),'INSERT INTO tblReceiptAllocation VALUES (3,2,30)'],lambda:(float(scalar('SELECT UnappliedOrOverAllocated FROM qry_05_ReceiptReconciliation WHERE ReceiptID=3')),20.0))
    scenario('T11 one receipt two visits',["INSERT INTO tblAppointment VALUES (3,1,1,#2026-11-14#,10,4.2,'Follow up','Recovered',50)",newreceipt(1,100),'INSERT INTO tblReceiptAllocation VALUES (3,2,60)','INSERT INTO tblReceiptAllocation VALUES (3,3,40)'],lambda:([float(r['OutstandingBalance']) for r in rows('SELECT * FROM qry_04_AppointmentBalance WHERE AppointmentID IN (2,3) ORDER BY AppointmentID')],[30.0,10.0]))
    scenario('T13 edit existing allocation',['UPDATE tblReceiptAllocation SET AppliedAmount=80 WHERE ReceiptID=1 AND AppointmentID=1'],lambda:(float(scalar('SELECT OutstandingBalance FROM qry_04_AppointmentBalance WHERE AppointmentID=1')),20.0))
    for label,sql,expected in [('T14 reduced receipt','UPDATE tblCashReceipt SET ReceiptTotal=90 WHERE ReceiptID=1','Receipt Over-Allocated'),('T15 reduced fee','UPDATE tblAppointment SET AppointmentFee=100 WHERE AppointmentID=1','Appointment Over-Paid'),('T17 historical price edit','UPDATE tblPrescriptionLine SET UnitPriceCharged=20 WHERE AppointmentID=1 AND MedicationID=1','Appointment Over-Paid')]:
        scenario(label,[sql],lambda e=expected:([r['ExceptionType'] for r in rows('qry_Ctrl_InvalidAllocations')],[e]))
    scenario('T16 catalog price preserves history',['UPDATE tblMedication SET ListPrice=99 WHERE MedicationID=1'],lambda:(float(scalar('SELECT TotalAppointmentCharge FROM qry_03_AppointmentTotal WHERE AppointmentID=1')),205.0))
    scenario('T18 duplicate vet name allowed',["INSERT INTO tblVeterinarian VALUES (3,'Dr. Nottingham','Test')"],lambda:(scalar("SELECT Count(*) FROM tblVeterinarian WHERE VetName='Dr. Nottingham'"),2))
    scenario('T18 duplicate parent name allowed',["INSERT INTO tblPetParent VALUES (3,'Emily Chen','Test','123','456')"],lambda:(scalar("SELECT Count(*) FROM tblPetParent WHERE ParentName='Emily Chen'"),2))
    scenario('T21 documented ownership-history limitation',['UPDATE tblPet SET ParentID=2 WHERE PetID=1'],lambda:(scalar('SELECT ParentID FROM qry_00_AppointmentOwner WHERE AppointmentID=1'),2))
    scenario('T22 documented cross-table date limitation',['UPDATE tblAppointment SET AppointmentDate=#2020-01-01# WHERE AppointmentID=1'],lambda:(rows('SELECT AppointmentDate FROM tblAppointment WHERE AppointmentID=1')[0]['AppointmentDate'].year,2020))
    save()
    # Use Access' supported module import rather than modifying trust/security settings.
    try:
        app.LoadFromText(5,'modAllocationValidation',str(ROOT/'technical/modAllocationValidation.bas'))
        def issue(r,a,v,oldr=None,olda=None):
            def vl(x): return 'Null' if x is None else str(x)
            return app.Eval('AllocationIssue('+','.join(vl(x) for x in (r,a,v,oldr,olda))+')')
        check('V06 helper valid edit excludes old amount',issue(1,1,80,1,1)=='')
        check('V06 helper unchanged amount',issue(1,1,100,1,1)=='')
        check('V02 helper null',len(issue(None,1,10))>0)
        check('V02 helper negative',len(issue(1,1,-1))>0)
        check('V02 helper decimal',len(issue(1,1,10.001))>0)
        check('V07 helper edit keys',len(issue(1,2,10,1,1))>0)
        check('helper duplicate pair',len(issue(1,1,10))>0)
        check('helper missing record',len(issue(999,1,10))>0)
        execute(newreceipt(1,120))
        try:
            check('V01 helper valid new allocation',issue(3,2,30)=='')
            check('V05 helper appointment overpaid','appointment charge' in issue(3,2,100))
            execute('UPDATE tblCashReceipt SET ReceiptTotal=50 WHERE ReceiptID=3')
            check('V04 helper receipt overallocated','receipt total' in issue(3,2,60))
            execute('UPDATE tblCashReceipt SET ParentID=2 WHERE ReceiptID=3')
            check('V03 helper cross-parent','Cross-parent' in issue(3,2,40))
        finally: execute('DELETE FROM tblCashReceipt WHERE ReceiptID=3')
        db.QueryDefs('qry_00_AppointmentOwner').Name='qry_00_AppointmentOwner_TEST_RENAMED'
        try: check('V08 helper fails closed on missing query','Validation failed' in issue(1,1,80,1,1))
        finally: db.QueryDefs('qry_00_AppointmentOwner_TEST_RENAMED').Name='qry_00_AppointmentOwner'
        log['vba_helper']='Executed by Access.Application.Eval; form event wiring not tested.'
    except Exception as e:
        log['vba_helper']='NOT RUN/INCOMPLETE: '+str(e)
        log['checks'].append({'name':'VBA helper execution','status':'NOT RUN','actual':str(e)})
    check('final clean baseline restored',len(rows('qry_Ctrl_InvalidAllocations'))==0 and scalar('SELECT Count(*) FROM tblCashReceipt')==2 and scalar('SELECT Count(*) FROM tblAppointment')==2)
    log['sample_counts']={t['name']:scalar('SELECT Count(*) FROM '+t['name']) for t in spec['tables']}
    relation_snapshot=[]
    for rel in db.Relations:
        if rel.Name.startswith('rel_'):
            relation_snapshot.append(dict(name=rel.Name,table=rel.Table,foreign_table=rel.ForeignTable,attributes=rel.Attributes,fields=[(f.Name,f.ForeignName) for f in rel.Fields]))
    log['relation_snapshot']=relation_snapshot
    check('relationship metadata: enforced, no cascade delete',all((r['attributes'] & (2|4096))==0 for r in relation_snapshot) and len(relation_snapshot)==12)
    pk_snapshot={}
    for t in spec['tables']:
        td=db.TableDefs(t['name'])
        pk_snapshot[t['name']]=[f.Name for f in td.Indexes('PrimaryKey').Fields]
    log['primary_keys']=pk_snapshot
    check('three composite keys match dictionary',pk_snapshot['tblPrescriptionLine']==['AppointmentID','MedicationID'] and pk_snapshot['tblReceiptAllocation']==['ReceiptID','AppointmentID'] and pk_snapshot['tblMedicationInteraction']==['MedicationAID','MedicationBID'])
    check('doctor name index allows duplicates',not db.TableDefs('tblVeterinarian').Indexes('ix_VetName').Unique)
    db=None
    ws=None
    app.CloseCurrentDatabase()
    app.OpenCurrentDatabase(log['database'])
    db=app.CurrentDb()
    check('database reopen retains valid baseline',len(rows('qry_Ctrl_InvalidAllocations'))==0 and scalar('SELECT TotalAppointmentCharge FROM qry_03_AppointmentTotal WHERE AppointmentID=1')==205)
except Exception:
    log['fatal']=traceback.format_exc()
    print(log['fatal'],flush=True)
finally:
    log['finished']=datetime.datetime.now().isoformat()
    save()
    if app is not None:
        try: app.CloseCurrentDatabase()
        except Exception: pass
        try: app.Quit(2)
        except Exception: pass
    print('RESULTS '+str(run/'test_results.json'),flush=True)

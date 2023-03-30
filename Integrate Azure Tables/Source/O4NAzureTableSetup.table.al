table 65900 "O4N Azure Table Setup"
{
    Caption = 'Azure Table Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin
                TestField("Storage Account Name");
                TestField("Storage Account Table Name");
                if Enabled then
                    Enabled := HasAccessKey();
                if Enabled then
                    Enabled := VerifyAccessKey();
                if CanScheduleJobQueue() then
                    if Enabled and not Rec."Manual Synchronization" then begin
                        ScheduleJobQueueEntry();
                        if Confirm(JobQEntriesCreatedQst) then
                            ShowJobQueueEntry();
                    end else
                        CancelJobQueueEntry();
            end;
        }
        field(3; "Storage Account Name"; Text[30])
        {
            Caption = 'Storage Account Name';
            DataClassification = CustomerContent;
        }
        field(4; "Storage Account Table Name"; Text[250])
        {
            Caption = 'Storage Account Table Name';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupTable();
            end;
        }
        field(5; "Storage Account Access Key ID"; Guid)
        {
            Caption = 'Storage Account Access Key ID';
            DataClassification = SystemMetadata;
        }
        field(10; "Manual Synchronization"; Boolean)
        {
            Caption = 'Manual Synchronization';
            DataClassification = SystemMetadata;
        }
        field(12; "Log Activity"; Boolean)
        {
            Caption = 'Log Activity';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        JobQEntriesCreatedQst: Label 'Job queue entries for integration with Azure Storage Table have been created.\\Do you want to open the Job Queue Entries window?';

    trigger OnDelete()
    begin
        DeleteAccessKey();
    end;

    procedure InitializeAccessKeySetup()
    begin
        if Get() then exit;
        Init();
        Insert();
    end;

    procedure HasAccessKey(): Boolean
    begin
        if IsNullGuid("Storage Account Access Key ID") then
            "Storage Account Access Key ID" := CreateGuid();
        exit(IsolatedStorage.Contains("Storage Account Access Key ID", DataScope::Module));
    end;

    procedure GetAccessKey() AccessKey: Text;
    begin
        if not HasAccessKey() then exit('');
        IsolatedStorage.Get("Storage Account Access Key ID", DataScope::Module, AccessKey);
    end;

    procedure SetAccessKey(AccessKey: Text)
    begin
        if HasAccessKey() then
            IsolatedStorage.Delete("Storage Account Access Key ID", DataScope::Module);
        if AccessKey = '' then exit;
        if EncryptionEnabled() then
            IsolatedStorage.SetEncrypted("Storage Account Access Key ID", AccessKey, DataScope::Module)
        else
            IsolatedStorage.Set("Storage Account Access Key ID", AccessKey, DataScope::Module);
        Modify();
    end;

    procedure DeleteAccessKey()
    begin
        if HasAccessKey() then
            IsolatedStorage.Delete("Storage Account Access Key ID", DataScope::Module);
    end;

    procedure ScheduleJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        DummyRecId: RecordID;
    begin
        CancelJobQueueEntry();
        JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
          CODEUNIT::"O4N Azure Table Job Queue", DummyRecId);
    end;

    procedure CancelJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"O4N Azure Table Job Queue") then
            JobQueueEntry.Cancel();
    end;

    procedure ShowJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"O4N Azure Table Job Queue") then
            PAGE.Run(PAGE::"Job Queue Entries", JobQueueEntry);
    end;

    procedure CanScheduleJobQueue(): Boolean
    var
        User: Record User;
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if not User.Get(UserSecurityId()) then exit(false);
        if User."License Type" <> User."License Type"::"Full User" then exit(false);
        exit(JobQueueEntry.WritePermission());
    end;

    local procedure VerifyAccessKey(): Boolean
    var
        TempBuffer: Record "Name/Value Buffer" temporary;
    begin
        GetTableList(TempBuffer);
        TempBuffer.SetRange(Name, Rec."Storage Account Table Name");
        exit(not TempBuffer.IsEmpty());
    end;

    local procedure GetTableList(var Buffer: Record "Name/Value Buffer")
    var
        TableAPI: Codeunit "O4N Azure Table API";
    begin
        TableAPI.QueryTables("Storage Account Name", GetAccessKey(), Buffer);
    end;

    local procedure LookupTable()
    var
        TempBuffer: Record "Name/Value Buffer" temporary;
    begin
        if "Storage Account Name" = '' then exit;
        if not Rec.HasAccessKey() then exit;
        GetTableList(TempBuffer);
        if Page.RunModal(Page::"O4N Azure Table List", TempBuffer) = Action::LookupOK then
            "Storage Account Table Name" := TempBuffer.Name;
    end;
}

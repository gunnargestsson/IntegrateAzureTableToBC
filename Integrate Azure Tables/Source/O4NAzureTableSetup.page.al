page 65900 "O4N Azure Table Setup"
{

    Caption = 'Azure Table Setup';
    PageType = Card;
    SourceTable = "O4N Azure Table Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    ShowFilter = false;
    UsageCategory = Administration;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Report,Encryption,Navigate';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Storage Account Name"; Rec."Storage Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Storage Account Name field';
                    ShowMandatory = true;
                    Editable = EditableByNotEnabled;
                }
                field("Storage Account Table Name"; Rec."Storage Account Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Storage Account Table Name field';
                    ShowMandatory = true;
                    Editable = EditableByNotEnabled;
                }
                field(StorageAccountAccessKeyField; AccessKey)
                {
                    ApplicationArea = All;
                    Caption = 'Storage Account Access Key';
                    ToolTip = 'Specifies the value of the Storage Account Access Key field';
                    ShowMandatory = true;
                    ExtendedDatatype = Masked;
                    Editable = EditableByNotEnabled;
                    trigger OnValidate()
                    begin
                        Rec.SetAccessKey(AccessKey);
                    end;
                }
                field("Manual Synchronization"; Rec."Manual Synchronization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manual Synchronization field';
                    Editable = EditableByNotEnabled;
                }
                field("Log Activity"; Rec."Log Activity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Log Activity field';
                    Editable = EditableByNotEnabled;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enabled field';
                    trigger OnValidate()
                    begin
                        UpdateBasedOnEnable();
                    end;
                }
                field(ShowEnableWarningField; ShowEnableWarning)
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Editable = false;
                    Enabled = NOT EditableByNotEnabled;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        DrilldownCode();
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(JobQueueEntry)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Queue Entry';
                Enabled = Rec.Enabled;
                Image = JobListSetup;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'View or edit the jobs that automatically integrate your time sheet with Clockify.';

                trigger OnAction()
                begin
                    Rec.ShowJobQueueEntry();
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'See the status and any errors integration with Clockify.';

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec);
                end;
            }
        }
        area(Navigation)
        {
            action(SaveTableEntities)
            {
                ApplicationArea = All;
                Caption = 'Save Table Entities Xml';
                ToolTip = 'Save the table entities Xml to a file.';
                Image = InteractionLog;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileMgt: Codeunit "File Management";
                    TableAPI: Codeunit "O4N Azure Table API";
                    Xml: XmlDocument;
                    OutStr: OutStream;
                begin
                    Xml := TableAPI.QueryEntities(Rec."Storage Account Name", Rec."Storage Account Table Name", Rec.GetAccessKey());
                    TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
                    Xml.WriteTo(OutStr);
                    FileMgt.BLOBExport(TempBlob, 'Entities.xml', true);
                end;
            }
            action(ViewTableEntities)
            {
                ApplicationArea = All;
                Caption = 'View Table Entities';
                ToolTip = 'View the table entities.';
                Image = InteractionLog;
                trigger OnAction()
                var
                    TempEntity: Record "O4N Azure Table Entity" temporary;
                    TableAPI: Codeunit "O4N Azure Table API";
                begin
                    TableAPI.QueryEntities(Rec."Storage Account Name", Rec."Storage Account Table Name", Rec.GetAccessKey(), TempEntity);
                    Page.RunModal(Page::"O4N Azure Table Entities", TempEntity);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InitializeAccessKeySetup();
        UpdateBasedOnEnable();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        AccessKey := Rec.GetAccessKey();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateBasedOnEnable();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Rec.Enabled then
            if not Confirm(StrSubstNo(EnableServiceQst, CurrPage.Caption), true) then
                exit(false);
    end;

    var
        AccessKey: Text;
        ShowEnableWarning: Text;
        EditableByNotEnabled: Boolean;
        EnabledWarningTok: Label 'You must disable the service before you can make changes.';
        DisableEnableQst: Label 'Do you want to disable the Azure Storage Table integation?';
        EnableServiceQst: Label 'The %1 is not enabled. Are you sure you want to exit?', Comment = '%1 = pagecaption (Azure Table Setup)';

    local procedure UpdateBasedOnEnable()
    begin
        EditableByNotEnabled := (not Rec.Enabled) and CurrPage.Editable;
        ShowEnableWarning := '';
        if CurrPage.Editable and Rec.Enabled then
            ShowEnableWarning := EnabledWarningTok;
    end;

    local procedure DrilldownCode()
    begin
        if Confirm(DisableEnableQst, true) then begin
            Rec.Enabled := false;
            UpdateBasedOnEnable();
            CurrPage.Update();
        end;
    end;
}

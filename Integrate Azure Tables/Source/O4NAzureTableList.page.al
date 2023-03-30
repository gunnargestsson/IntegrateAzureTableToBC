page 65901 "O4N Azure Table List"
{

    Caption = 'Azure Table List';
    PageType = List;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    UsageCategory = none;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Table Name in Azure Storage Account.';
                }
            }
        }
    }

}
